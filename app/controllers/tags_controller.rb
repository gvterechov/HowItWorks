class TagsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :set_user_tag, only: [:destroy, :edit, :update]

  def index
    @tags = current_user.task_tags.order(:created_at)
  end

  def new
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
  end

  def create
    tag_name = params[:tag_name].to_s.strip
    selected_task_ids = Array(params[:selected_task_ids])

    tag = TaskTag.find_or_create_by(name: tag_name, user: current_user)

    selected_task_ids.each do |task_id|
      ExpressionTaskTag.find_or_create_by(expression_task_id: task_id, task_tag_id: tag.id)
    end

    flash[:success] = "Тег успешно сохранён и привязан к задачам"
    redirect_to tags_path(locale: I18n.locale)
  end

  def destroy
    @task_tag.destroy
    redirect_to tags_path(locale: I18n.locale), notice: t('tag_deleted', default: 'Тег удалён')
  end

  def edit
    @tasks = current_user.expression_tasks.order(:created_at)
    @selected_task_ids = (params[:selected_task_ids] || @task_tag.expression_tasks.pluck(:id).map(&:to_s))

    if params[:add_task_id]
      @selected_task_ids << params[:add_task_id].to_s unless @selected_task_ids.include?(params[:add_task_id].to_s)
    elsif params[:remove_task_id]
      @selected_task_ids.delete(params[:remove_task_id].to_s)
    end

    @selected_task_ids.uniq!
  end

  def update
    @task_tag.name = params[:tag_name]
    task_ids = (params[:selected_task_ids] || []).map(&:to_i)

    @task_tag.expression_tasks = ExpressionTask.where(id: task_ids, user: current_user)
    if @task_tag.save
      flash[:success] = 'Тег обновлён'
    else
      flash[:error] = 'Ошибка при сохранении тега'
    end

    redirect_to tags_path(locale: I18n.locale)
  end

  private

    def set_user_tag
      @task_tag = TaskTag.find(params[:id])
      if @task_tag.user != current_user
        redirect_to tags_path(locale: I18n.locale), alert: 'У вас нет доступа к этому тегу' and return
      end
    end
end
