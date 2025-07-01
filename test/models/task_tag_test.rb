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
require "test_helper"

class TaskTagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
