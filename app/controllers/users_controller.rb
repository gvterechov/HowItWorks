class UsersController < ApplicationController
  before_action :authenticate_user!

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

  private
    def find_task_by_url(url)
      url_parts = url.split('/')
      task_token = url_parts.last
      task_model = url_parts[-3].singularize
                               .concat('Task')
                               .classify
                               .constantize

      task_model.find_by(token: task_token)
    end
end
