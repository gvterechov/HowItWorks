class TeacherFeedbacksController < ApplicationController
  skip_before_action :verify_authenticity_token

  # POST /feedback.json
  def create
    @feedback = TeacherFeedback.new(teacher_feedback_params)

    respond_to do |format|
      if @feedback.save
        format.json { render json: @feedback, status: :created }
      else
        format.json { render json: @feedback.errors, status: :unprocessable_entity }
      end
    end
  end

  private

    def teacher_feedback_params
      params.require(:teacher_feedback).permit(:full_name, :institution, :position, :feedback)
    end
end
