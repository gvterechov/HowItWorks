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
#  title       :string           default("")
#
class ExpressionTask < ApplicationRecord
  has_many :attempts, as: :task

  before_create :set_token

  validates :title, presence: true

  def best_attempt
    attempts.was_done.order(:total_steps).first
  end

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
