# == Schema Information
#
# Table name: taggings
#
#  id            :bigint           not null, primary key
#  task_tag_id   :bigint           not null
#  taggable_type :string           not null
#  taggable_id   :bigint           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Tagging < ApplicationRecord
  belongs_to :task_tag
  belongs_to :taggable, polymorphic: true
end
