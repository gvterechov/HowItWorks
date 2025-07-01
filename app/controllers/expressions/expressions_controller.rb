class Expressions::ExpressionsController < ApplicationController
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

  private
    def check_trainer_available!
      raise BaseService::ServiceNotAvailableException.new unless OwlEvaluationOrderCheck.new.available?
    end
end
