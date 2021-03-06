# == Schema Information
#
# Table name: attempts
#
#  id           :bigint           not null, primary key
#  student_name :string           default("")
#  total_steps  :integer          default(0)
#  error_steps  :integer          default(0)
#  done         :boolean          default(FALSE)
#  task_type    :string
#  task_id      :bigint
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  hint_steps   :integer          default(0)
#
class Attempt < ApplicationRecord
  belongs_to :task, polymorphic: true

  validates :student_name, presence: true, length: { minimum: 2 }

  scope :was_done, -> { where(done: true) }

  def increment_steps(was_hint: false, was_error: false, done: false)
    params = { total_steps: self.total_steps + 1 }
    params[:hint_steps] = self.hint_steps + 1 if was_hint
    params[:error_steps] = self.error_steps + 1 if was_error
    params[:done] = done
    self.update(params)
  end

  def done_at
    updated_at if done?
    nil
  end

  def duration
    Time.at(updated_at - created_at).utc
  end
end
