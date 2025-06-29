class Expressions::ExpressionsController < ApplicationController
  before_action :authenticate_user!, only: [:tasks, :task_statistic]
  before_action :check_trainer_available!, only: :index
  skip_before_action :verify_authenticity_token

  def index
    render '/expressions/index'
  end

  def check_expression
    data = JSON.parse(params[:data])
    result = OwlEvaluationOrderCheck.new.verify_expression(data)

    if params[:attempt_id].present?
      # Запросили подсказку - когда в параметрах присутствует соответствующий флаг
      was_hint = data['action'] == 'next_step'
      # Есть ошибка - когда статус хотя бы одного узла выражения 'wrong'
      was_error = result[:expression].any? { |elem| elem[:status] == 'wrong' }
      # Задача решена - когда нет кликабельных узлов выражения
      done = !result[:expression].any? { |elem| elem[:enabled] }

      attempt = Attempt.find(params[:attempt_id])
      if attempt.present?
        attempt.increment_steps(was_hint: was_hint, was_error: was_error, done: done)
        attempt.update(student_name: params[:student_name]) if attempt.student_name != params[:student_name].present?
      end
    end

    respond_to do |format|
      format.html { render partial: '/expressions/common/expression_trainer', locals: { data: result } }
    end
  end

  def get_supplement
    data = JSON.parse(params[:data])
    result = OwlEvaluationOrderCheck.new.verify_expression(data)
    result[:action] = :get_supplement
    result = OwlEvaluationOrderCheck.new.get_supplement(result)

    respond_to do |format|
      format.json { render json: result, status: :ok }
    end
  end

  def get_next_supplement
    data = JSON.parse(params[:data])
    result = OwlEvaluationOrderCheck.new.get_supplement(data)

    respond_to do |format|
      format.json { render json: result, status: :ok }
    end
  end

  def available_syntaxes
    result = OwlEvaluationOrderCheck.new.available_syntaxes
    available_syntaxes_names = { 'cpp' => 'C++', 'cs' => 'C#' }.freeze

    result[:available_syntaxes] =
      result[:expression].map do |elem|
        {
          name: available_syntaxes_names[elem[:text]] || elem[:text].camelize,
          value: elem[:text]
        }
      end
    result[:available_syntaxes].first[:selected] = true

    respond_to do |format|
      format.json { render json: result, status: :ok }
    end
  end

  def tags
    @tags = current_user.task_tags.order(:created_at)

    render '/expressions/tags'
  end

  def new_tag
    @tasks = current_user.expression_tasks.order(:created_at)
    @selected_task_ids = (params[:selected_task_ids] || []).map(&:to_s)
    @tag_name = params[:tag_name]

    if params[:add_task_id]
      add_id = params[:add_task_id].to_s
      @selected_task_ids << add_id unless @selected_task_ids.include?(add_id)
    elsif params[:remove_task_id]
      remove_id = params[:remove_task_id].to_s
      @selected_task_ids.delete(remove_id)
    end

    @selected_task_ids.uniq!

    render '/expressions/new_tag'
  end

  def create_tag
    tag_name = params[:tag_name].to_s.strip
    selected_task_ids = Array(params[:selected_task_ids])

    if tag_name.blank? || selected_task_ids.empty?
      flash[:error] = "Необходимо указать название тега и выбрать хотя бы одну задачу"
      redirect_to expressions_new_tag_path(tag_name: tag_name, selected_task_ids: selected_task_ids) and return
    end

    tag = TaskTag.find_or_create_by(name: tag_name, user: current_user)

    selected_task_ids.each do |task_id|
      ExpressionTaskTag.find_or_create_by(expression_task_id: task_id, task_tag_id: tag.id)
    end

    flash[:success] = "Тег успешно сохранён и привязан к задачам"
    redirect_to expressions_tags_path
  end

  def destroy_tag
    @tag = TaskTag.find(params[:id])
    if tag.user != current_user
      redirect_to expressions_tags_path, alert: 'У вас нет доступа к удалению этого тега' and return
    end

    tag.destroy
    redirect_to expressions_tags_path, notice: t('tag_deleted', default: 'Тег удалён')
  end

  def edit_tags
    @task_tag = TaskTag.find(params[:id])
    unless @task_tag.user == current_user
      redirect_to expressions_tags_path, alert: 'У вас нет доступа к этому тегу' and return
    end

    @tasks = current_user.expression_tasks.order(:created_at)
    @selected_task_ids = (params[:selected_task_ids] || @task_tag.expression_tasks.pluck(:id).map(&:to_s))

    if params[:add_task_id]
      @selected_task_ids << params[:add_task_id].to_s unless @selected_task_ids.include?(params[:add_task_id].to_s)
    elsif params[:remove_task_id]
      @selected_task_ids.delete(params[:remove_task_id].to_s)
    end

    @selected_task_ids.uniq!
    render '/expressions/edit_tags'
  end

  def update_tag
    @task_tag = TaskTag.find(params[:id])
    unless @task_tag.user == current_user
      redirect_to expressions_tags_path, alert: 'У вас нет доступа к этому тегу' and return
    end

    @task_tag.name = params[:tag_name]
    task_ids = (params[:selected_task_ids] || []).map(&:to_i)

    @task_tag.expression_tasks = ExpressionTask.where(id: task_ids, user: current_user)
    if @task_tag.save
      flash[:success] = 'Тег обновлён'
    else
      flash[:error] = 'Ошибка при сохранении тега'
    end

    redirect_to expressions_tags_path
  end

  private
    def check_trainer_available!
      raise BaseService::ServiceNotAvailableException.new unless OwlEvaluationOrderCheck.new.available?
    end
end
