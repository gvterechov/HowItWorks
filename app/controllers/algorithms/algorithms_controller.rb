class Algorithms::AlgorithmsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:verify_trace_act]

  def index
    render '/algorithms/index'
  end

  # TODO вынести в tasks_controller
  def show_task
    task = AlgorithmTask.find_by(token: params[:token])
    task.update_column(:views_count, task.views_count + 1)

    data = JSON.parse(task.data)

    @task_lang = data['task_lang']
    @result = COwl.creating_task(data)
    @hide_trace = true

    render params[:beta] ? '/algorithms/show_task_beta' : '/algorithms/show_task'
  end

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
                                        layout: false)
        }
      }
    end
  end

  # TODO вынести в tasks_controller
  def create_task
    task = AlgorithmTask.new(task_params)

    respond_to do |format|
      if task.save
        # TODO вот тут бы совсем правильный путь получить, с учетом языка клиента
        format.json { render json: { task_path: "/tasks/#{task.token}" }, status: :created }
      else
        head :bad_request
      end
    end
  end

  def verify_trace_act
    data = JSON.parse(params[:data])
    data[:syntax] = params[:task_lang]
    result = COwl.verify_trace_act(data)

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

  private
    # TODO вынести в tasks_controller
    def task_params
      params.require(:task).permit(:data)
    end
end
