class AttemptsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create]
  # POST /attempts.json
  def create
    new_attempt_params = attempt_params.slice(:student_name, :task_type)
    new_attempt_params[:task_id] = new_attempt_params[:task_type].constantize
                                                                 .find_by(token: attempt_params[:task_token])
                                                                 .id

    @attempt = Attempt.new(new_attempt_params)

    respond_to do |format|
      if @attempt.save
        format.json { render json: @attempt, status: :created }
      else
        format.json { render json: @attempt.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /attempts/1/statistic
  def statistic
    @attempt = Attempt.includes(task: :attempts).find_by(id: params[:id])

    respond_to do |format|
      if @attempt.present?
        format.html { render partial: 'expressions/common/attempt_statistic',
                             locals: { attempt: @attempt },
                             layout: false
        }
      else
        format.html { head :ok }
      end
    end
  end

  private
    def attempt_params
      params.require(:attempt).permit(:student_name, :task_type, :task_token)
    end
end
