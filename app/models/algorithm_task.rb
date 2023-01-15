# == Schema Information
#
# Table name: algorithm_tasks
#
#  id                 :bigint           not null, primary key
#  data               :string           not null
#  token              :string           not null
#  views_count        :integer          default(0)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  title              :string           default("")
#  user_id            :bigint
#  introduce_yourself :boolean          default(TRUE)
#
class AlgorithmTask < ApplicationRecord
  include TaskModule
  include Tokenable

  token_for_model :algorithm_task
end
