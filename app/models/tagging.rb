class Tagging < ApplicationRecord
  belongs_to :task_tag
  belongs_to :taggable, polymorphic: true
end
