# == Schema Information
#
# Table name: expression_task_tags
#
#  id                 :bigint           not null, primary key
#  expression_task_id :bigint           not null
#  task_tag_id        :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
class ExpressionTaskTag < ApplicationRecord
  belongs_to :expression_task
  belongs_to :task_tag
end
