class TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user_tag, only: [:destroy, :edit, :update]

  def index
    @tags = current_user.task_tags.order(:created_at)
  end

  def new
    @taggable_type = params[:taggable_type] || 'ExpressionTask'
    @taggable_class = @taggable_type.constantize

    @tag_name = params[:tag_name].to_s
    @selected_ids = (params[:selected_ids] || []).map(&:to_s)
    @items = current_user.send(@taggable_type.underscore.pluralize)

    if params[:add_id]
      @selected_ids << params[:add_id].to_s unless @selected_ids.include?(params[:add_id].to_s)
    elsif params[:remove_id]
      @selected_ids.delete(params[:remove_id].to_s)
    end

    @selected_ids.uniq!

    @task_tag = TaskTag.new(name: @tag_name)
  end

  def create
    tag_name = params[:tag_name].to_s.strip
    taggable_type = params[:taggable_type]
    taggable_class = taggable_type.constantize
    selected_ids = Array(params[:selected_ids])

    if current_user.task_tags.exists?(name: tag_name)
      flash.now[:error] = t("tags.tag_exist")

      @taggable_type = taggable_type
      @taggable_class = taggable_class
      @selected_ids = selected_ids
      @items = current_user.send(@taggable_type.underscore.pluralize)
      @task_tag = TaskTag.new(name: tag_name)

      return render :new, status: :unprocessable_entity
    end

    tag = current_user.task_tags.create(name: tag_name)

    selected_ids.each do |id|
      obj = taggable_class.find_by(id: id, user: current_user)
      next unless obj
      obj.taggings.find_or_create_by(task_tag: tag)
    end

    redirect_to tags_path
  end



  def edit
    @taggable_type = params[:taggable_type] || 'ExpressionTask'
    @taggable_class = @taggable_type.constantize
    @tasks = @taggable_class.all

    @selected_task_ids = (params[:selected_task_ids] || @task_tag.taggings.where(taggable_type: @taggable_type).pluck(:taggable_id).map(&:to_s)).uniq

    if params[:add_task_id].present?
      @selected_task_ids << params[:add_task_id].to_s unless @selected_task_ids.include?(params[:add_task_id].to_s)
    elsif params[:remove_task_id].present?
      @selected_task_ids.delete(params[:remove_task_id].to_s)
    end
    @selected_task_ids.uniq!
  end

  def update
    @task_tag.name = params[:tag_name]
    taggable_type = params[:taggable_type]
    taggable_class = taggable_type.constantize
    selected_ids = Array(params[:selected_ids]).map(&:to_i)

    @task_tag.taggings.where(taggable_type: taggable_type).where.not(taggable_id: selected_ids).destroy_all

    selected_ids.each do |id|
      taggable = taggable_class.find_by(id: id, user: current_user)
      next unless taggable
      @task_tag.taggings.find_or_create_by(taggable: taggable)
    end

    redirect_to tags_path
  end

  def destroy
    @task_tag.destroy
    redirect_to tags_path
  end

  private

  def set_user_tag
    @task_tag = current_user.task_tags.find(params[:id])
  end
end
