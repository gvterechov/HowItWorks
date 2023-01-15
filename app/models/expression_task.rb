# == Schema Information
#
# Table name: expression_tasks
#
#  id                 :bigint           not null, primary key
#  expression         :string           not null
#  task_lang          :string           not null
#  token              :string           not null
#  views_count        :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  title              :string           default("")
#  user_id            :bigint
#  introduce_yourself :boolean          default(TRUE)
#  enable_hints       :boolean          default(FALSE)
#  max_hints_count    :integer          default(0)
#
class ExpressionTask < ApplicationRecord
  include TaskModule
  include Tokenable

  token_for_model :expression_task
end
