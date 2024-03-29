module TaskModule
  extend ActiveSupport::Concern

  included do
    has_many :attempts, as: :task, dependent: :destroy
    belongs_to :user, optional: true

    validates :title, presence: true
  end

  def best_attempt
    attempts.was_done.order(:total_steps).first
  end

  def linked_to_user?
    user_id.present?
  end

  def claim(user)
    return if linked_to_user?
    update(user_id: user.id)
  end
end
