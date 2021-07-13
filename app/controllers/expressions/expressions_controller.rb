class Expressions::ExpressionsController < ApplicationController
  before_action :authenticate_user!, only: [:tasks, :task_statistic]

  def index
    render '/expressions/index'
  end

  # TODO вынести в tasks_controller
  def show_task
    @task = ExpressionTask.find_by(token: params[:token])
    @task.update_column(:views_count, @task.views_count + 1)

    @task_lang = @task.task_lang

    expression_json = JSON.parse(@task.expression)
    @expression_sting = expression_json.reduce("") { |memo, elem| memo << "#{elem['text']} " }.chop!

    expression = { expression: expression_json, lang: I18n.locale.to_s }

    @result_data = OwlEvaluationOrderCheck.call(expression)

    render '/expressions/show_task'
  end

  def check_expression
    data = JSON.parse(params[:data])
    result = OwlEvaluationOrderCheck.call(data)

    if params[:attempt_id].present?
      # Есть ошибка - когда статус хотя бы одного узла выражения 'wrong'
      was_error = result[:expression].any? { |elem| elem[:status] == 'wrong' }
      # Задача решена - когда нет кликабельных узлов выражения
      done = !result[:expression].any? { |elem| elem[:enabled] }

      Attempt.find(params[:attempt_id])
             &.increment_steps(was_error: was_error, done: done)
    end

    respond_to do |format|
      format.html { render partial: '/expressions/common/expression_trainer', locals: { data: result } }
    end
  end

  # TODO вынести в tasks_controller
  def create_task
    task = ExpressionTask.new(task_params)
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

  # TODO вынести в tasks_controller
  def tasks
    @tasks = current_user.expression_tasks
                         .includes(:attempts)
                         .order(:created_at)

    render '/expressions/tasks'
  end

  # TODO вынести в tasks_controller
  def task_statistic
    @task = current_user.expression_tasks
                        .includes(:attempts)
                        .find_by(token: params[:token])

    return if @task.blank?

    render '/expressions/task_statistic'
  end

  private
    # TODO вынести в tasks_controller
    def task_params
      params.require(:task).permit(:expression, :task_lang, :title, :introduce_yourself)
    end
end
