# == Schema Information
#
# Table name: algorithm_tasks
#
#  id          :bigint           not null, primary key
#  data        :string           not null
#  token       :string           not null
#  views_count :integer          default(0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  title       :string           default("")
#
class AlgorithmTask < ApplicationRecord
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
      break random_token unless AlgorithmTask.where(token: random_token).exists?
    end
  end
end
