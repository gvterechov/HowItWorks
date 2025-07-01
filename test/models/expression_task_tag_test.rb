# == Schema Information
#
# Table name: expression_task_tags
#
#  id                 :bigint           not null, primary key
#  expression_task_id :bigint           not null
#  task_tag_id        :bigint           not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
require "test_helper"

class ExpressionTaskTagTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
