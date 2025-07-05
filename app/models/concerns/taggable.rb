module Taggable
  extend ActiveSupport::Concern

  included do
    has_many :taggings, as: :taggable, dependent: :destroy
    has_many :task_tags, through: :taggings
  end

  def tag_with(tag_name, user)
    tag = TaskTag.find_or_create_by(name: tag_name, user: user)
    taggings.find_or_create_by(task_tag: tag)
  end

  def retag!(tag_ids, user)
    new_tags = TaskTag.where(id: tag_ids, user: user)
    self.task_tags = new_tags
  end
end
