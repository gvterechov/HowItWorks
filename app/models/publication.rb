# == Schema Information
#
# Table name: publications
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Publication < ApplicationRecord
  has_rich_text :content
end
