module Expressions::TaskHelper
  # Наименование языка программирования по его ключу,
  # используемому в сервисе для работы с выражениями
  def expression_language_name(task_lang)
    {
      'cpp' => 'C++',
      'python' => 'Python'
    }[task_lang]
  end
end
