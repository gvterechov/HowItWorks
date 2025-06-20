class ExpressionTaskTag < ApplicationRecord
  belongs_to :expression_task
  belongs_to :task_tag
end
