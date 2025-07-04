class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!, only: [:index, :edit, :update, :destroy]

  def claim_task
    task = find_task_by_url(params[:task_url])

    message =
      if task.blank?
        t('task_claim.not_exists')
      else
        if task.user_id == current_user.id
          t('task_claim.your_task', task_title: task.title)
        elsif task.claim(current_user)
          t('task_claim.success', task_title: task.title)
        else
          t('task_claim.have_user', task_title: task.title)
        end
      end

    render json: { message: message }, status: :ok
  end

  def index
    @users = User.order(:created_at).page(params[:page]).per(30)
  end

  def edit
    @user = User.find(params[:id])
    @available_roles = ['basic', 'admin']
  end

  def update
    @user = User.find(params[:id])
    new_roles = Array(user_params[:roles]).reject(&:blank?)

    if prevent_admin_demotion?(@user, new_roles)
      flash[:alert] = "Нельзя снять роль администратора с самого себя"
      redirect_to users_path(locale: I18n.locale)
    elsif @user.update(roles: new_roles)
      flash[:notice] = "Пользователь обновлён"
      redirect_to users_path(locale: I18n.locale)
    else
      flash.now[:alert] = "Ошибка при обновлении"
      @available_roles = ['basic', 'admin']
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])

    if user == current_user
      flash[:alert] = "Вы не можете удалить самого себя"
    elsif user.destroy
      flash[:notice] = "Пользователь удалён"
    else
      flash[:alert] = "Ошибка при удалении пользователя"
    end

    redirect_to users_path(locale: I18n.locale)
  end

  private

    def user_params
      params.require(:user).permit(roles: [])
    end

    def require_admin!
      unless current_user&.admin?
        flash[:alert] = 'Доступ запрещён'
        redirect_to root_path(locale: I18n.locale)
      end
    end

    def find_task_by_url(url)
      url_parts = url.split('/')
      task_token = url_parts.last
      task_model = url_parts[-3].singularize.concat('Task').classify.constantize
      task_model.find_by(token: task_token)
    end

    def prevent_admin_demotion?(user, new_roles)
      user == current_user &&
        user.admin? &&
        !new_roles.include?('admin')
    end
end
