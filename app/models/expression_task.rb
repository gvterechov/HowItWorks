# == Schema Information
#
# Table name: expression_tasks
#
#  id          :bigint           not null, primary key
#  expression  :string           not null
#  task_lang   :string           not null
#  token       :string           not null
#  views_count :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class ExpressionTask < ApplicationRecord
  before_create :set_token

  private

  def set_token
    self.token = generate_token
  end

  def generate_token
    loop do
      random_token = SecureRandom.hex
      break random_token unless ExpressionTask.where(token: random_token).exists?
    end
  end
end