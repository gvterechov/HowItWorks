# == Schema Information
#
# Table name: teacher_feedbacks
#
#  id          :bigint           not null, primary key
#  full_name   :string           not null
#  institution :string           not null
#  position    :string           not null
#  feedback    :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class TeacherFeedback < ApplicationRecord
  validates :full_name, :institution, :position, presence: true, length: { minimum: 2 }
  validates :full_name, uniqueness: true
end
