class TaskTag < ApplicationRecord
  belongs_to :user

  has_many :expression_task_tags, dependent: :destroy
  has_many :expression_tasks, through: :expression_task_tags
end
