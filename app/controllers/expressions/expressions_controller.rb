class Expressions::ExpressionsController < ApplicationController
  def index
    render '/expressions/index'
  end

  # TODO вынести в tasks_controller
  def show_task
    task = Task.find_by(token: params[:token])
    task.update_column(:views_count, task.views_count + 1)

    @task_lang = task.task_lang

    expression_json = JSON.parse(task.expression)
    @expression_sting = expression_json.reduce("") { |memo, elem| memo << "#{elem['text']} " }.chop!

    expression = { expression: expression_json, lang: I18n.locale.to_s }

    @result_data = OwlEvaluationOrderCheck.call(expression)

    render '/expressions/show_task'
  end

  def check_expression
    data = JSON.parse(params[:data])
    result = OwlEvaluationOrderCheck.call(data)

    respond_to do |format|
      format.html { render partial: '/expressions/common/expression_trainer', locals: { data: result } }
    end
  end

  # TODO вынести в tasks_controller
  def create_task
    task = Task.new(task_params)

    respond_to do |format|
      if task.save
        # TODO вот тут бы совсем правильный путь получить, с учетом языка клиента
        format.json { render json: { task_path: "/tasks/#{task.token}" }, status: :created }
      else
        head :bad_request
      end
    end
  end

  private
    # TODO вынести в tasks_controller
    def task_params
      params.require(:task).permit(:expression, :task_lang)
    end
end
