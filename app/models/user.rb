# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  roles                  :string           default([]), not null, is an Array
#
class User < ApplicationRecord
  # EMAIL_REGEX = /\A[A-Za-z0-9](([_\\.\\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\\.\\-]?[a-zA-Z0-9]+)*)\.([A-Za-z]{2,})\z/

  extend Enumerize
  
  ROLES = %i[admin basic].freeze

  enumerize :roles, in: ROLES, multiple: true, predicates: true

  has_many :expression_tasks, dependent: :destroy
  has_many :task_tags, dependent: :destroy
  has_many :algorithm_tasks, dependent: :destroy

  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable

  after_initialize :set_default_roles, if: :new_record?

  private

  def set_default_roles
    self.roles = ['basic'] if roles.blank?
  end


  # validates :email, presence: { message: 'Email должен быть указан!' },
  #           uniqueness: { message: 'Такой пользователь уже существует!' },
  #           format: { with: EMAIL_REGEX }
end
