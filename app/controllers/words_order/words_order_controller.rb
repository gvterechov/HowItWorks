class WordsOrder::WordsOrderController < ApplicationController
  before_action :check_trainer_available!, only: :index
  skip_before_action :verify_authenticity_token

  def index
    # TODO случайным образом достаем одну из заготовленных задач
    # @task = WordsOrderTask.order(Arel.sql('RANDOM()')).first
    data = get_new_random_task

    data[:wordsToSelect].shuffle!
    @task = WordsOrderTask.new(data)

    render '/words_order/index'
  end

  def check_expression
    data = JSON.parse(params[:data])
    data["wordsToSelect"] = JSON.parse(data["wordsToSelect"])
    data['lang'] = WordsOrder::AVAILABLE_LANGUAGES[data['lang'].to_sym]

    result = WordsOrder.new.verify(data)
    task = WordsOrderTask.new(result)

    respond_to do |format|
      format.html { render partial: '/words_order/common/sentence_trainer', locals: { task: task } }
    end
  end

  private
    def check_trainer_available!
      raise BaseService::ServiceNotAvailableException.new unless WordsOrder.new.available?
    end

    def get_new_random_task
      # Берем список уже выданных задач из кук
      used_tasks = JSON.parse(cookies[:tasks_ids] || '[]')
      new_task = WordsOrder::GiveTask.new.call(used_tasks)
      # Закоминаем выданную задачу в куках
      cookies[:tasks_ids] = JSON.generate(used_tasks.push(new_task[:id]))
      new_task
    end
end
