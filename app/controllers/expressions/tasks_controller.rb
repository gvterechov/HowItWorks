class Expressions::TasksController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def show
    @task = ExpressionTask.find_by(token: params[:token])
    @task.update_column(:views_count, @task.views_count + 1)

    @task_lang = @task.task_lang
    expression_json = JSON.parse(@task.expression)
    @expression_sting = expression_json.reduce("") { |memo, elem| memo << "#{elem['text']} " }.chop!

    expression = { expression: expression_json, lang: I18n.locale.to_s }
    @result_data = OwlEvaluationOrderCheck.new.verify_expression(expression)
  end

  def create
    task = ExpressionTask.new(task_params)
    task.user_id = current_user.id

    respond_to do |format|
      if task.save
        format.json { render json: { task_path: "/tasks/#{task.token}", task_title: task.title }, status: :created }
      else
        head :bad_request
      end
    end
  end

  def index
    @all_tags = current_user.task_tags.order(:name)
    @selected_tag_ids = (params[:filter_tag_ids] || []).map(&:to_i)

    @tasks = current_user.expression_tasks.includes(:attempts, :task_tags).order(:created_at)
    if @selected_tag_ids.any?
      @tasks = @tasks.joins(:task_tags).where(task_tags: { id: @selected_tag_ids }).distinct
    end
  end

  def statistic
    @task = current_user.expression_tasks.includes(:attempts).find_by!(token: params[:token])
  end

  private

    def task_params
      params.require(:task).permit(:expression, :task_lang, :title, :introduce_yourself,
                                  :enable_hints, :max_hints_count)
    end
end
