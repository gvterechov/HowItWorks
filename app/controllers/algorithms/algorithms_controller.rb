class Algorithms::AlgorithmsController < ApplicationController
  before_action :authenticate_user!, only: [:tasks, :task_statistic]
  skip_before_action :verify_authenticity_token, only: [:verify_trace_act, :create_task]

  def index
    render '/algorithms/index'
  end

  # TODO вынести в tasks_controller
  def show_task
    @task = AlgorithmTask.find_by(token: params[:token])
    @task.update_column(:views_count, @task.views_count + 1)

    data = JSON.parse(@task.data)

    @task_lang = data['task_lang']
    @task_token = @task.token
    @task_type = @task.class.name
    @result = COwl.creating_task(data)
    @preview_mode = false
    @hide_trace = true

    render params[:beta] ? '/algorithms/show_task_beta' : '/algorithms/show_task'
  end

  def preview_task
    # preview mode
    @task = {
      token: 'null'
    }
    @result = {
      syntax_errors: [],
      algorithm_json: {},
      algorithm_as_html: t('algorithms.index.algorithm_loading'),
      trace_json: []
    }
    @task_lang = 'C++' # just avoiding invalid values
    @task_token = 'null'
    @task_type = 'null'

    @preview_mode = true
    @hide_trace = true

    render params[:beta] ? '/algorithms/show_task_beta' : '/algorithms/show_task'
  end

  # TODO объединить с verify_trace_act?
  def check_expression
    data = JSON.parse(params[:data])
    data[:syntax] = data[:task_lang]
    result = COwl.creating_task(data)

    respond_to do |format|
      format.html {
        render json: {
          trace_html: render_to_string(partial: '/algorithms/common/trace_field',
                                       locals: {
                                         data: result
                                       },
                                       layout: false),
          errors_html: render_to_string(partial: '/algorithms/index/errors',
                                        locals: {
                                          errors: result[:syntax_errors]
                                        },
                                        layout: false),
          algorithm_json: result[:algorithm_json],
          algorithm_as_html: result[:algorithm_as_html]
        }
      }
    end
  end

  # TODO вынести в tasks_controller
  def create_task
    task = AlgorithmTask.new(task_params)
    task.user_id = current_user.id if current_user.present?

    respond_to do |format|
      if task.save
        # TODO вот тут бы совсем правильный путь получить, с учетом языка клиента
        format.json { render json: { task_path: "/tasks/#{task.token}", task_title: task.title }, status: :created }
      else
        head :bad_request
      end
    end
  end

  def verify_trace_act
    data = JSON.parse(params[:data])
    data[:syntax] = params[:task_lang]
    result = COwl.verify_trace_act(data)

    if params[:attempt_id].present?
      # Есть ошибка - когда статус хотя бы одного узла выражения 'wrong'
      was_error = false
      # Задача решена - когда нет кликабельных узлов выражения
      done = false

      trace_json = (result[:full_trace_json] || result[:trace_json])
      if trace_json.present?
        was_error = trace_json.any? { |elem| !elem[:is_valid] }
        done = trace_json.any? { |elem| elem[:is_final] }
      end

      Attempt.find(params[:attempt_id])
        &.increment_steps(was_error: was_error, done: done)
    end

    respond_to do |format|
      format.html {
        # render partial: '/algorithms/show_task/algorithm_trainer',
        render partial: (true ? '/algorithms/show_task/algorithm_trainer_beta' : '/algorithms/show_task/algorithm_trainer'),
               locals: {
                 data: result,
                 task_lang: params[:task_lang],
                 hide_trace: false
               }
      }
    end
  end

  def available_syntaxes
    result = COwl.available_syntaxes
    result[:available_syntaxes].map! do |elem|
      {
        name: elem,
        value: elem
      }
    end
    result[:available_syntaxes].first[:selected] = true

    respond_to do |format|
      format.json { render json: result, status: :ok }
    end
  end

  # TODO вынести в tasks_controller
  def tasks
    @tasks = current_user.algorithm_tasks
                         .includes(:attempts)
                         .order(:created_at)

    render '/algorithms/tasks'
  end

  # TODO вынести в tasks_controller
  def task_statistic
    @task = current_user.algorithm_tasks
                        .includes(:attempts)
                        .find_by(token: params[:token])

    return if @task.blank?

    render '/algorithms/task_statistic'
  end

  private
    # TODO вынести в tasks_controller
    def task_params
      params.require(:task).permit(:data, :title, :introduce_yourself)
    end
end
