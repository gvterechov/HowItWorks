# == Schema Information
#
# Table name: task_tags
#
#  id         :bigint           not null, primary key
#  name       :string
#  user_id    :bigint           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class TaskTag < ApplicationRecord
  belongs_to :user

  has_many :taggings, dependent: :destroy
  has_many :taggables, through: :taggings
end
