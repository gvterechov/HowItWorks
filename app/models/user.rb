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
#  roles                  :string           default: [], null: false, array: true
#
class User < ApplicationRecord
  # EMAIL_REGEX = /\A[A-Za-z0-9](([_\\.\\-]?[a-zA-Z0-9]+)*)@([A-Za-z0-9]+)(([\\.\\-]?[a-zA-Z0-9]+)*)\.([A-Za-z]{2,})\z/

  has_many :expression_tasks, dependent: :destroy
  has_many :task_tags, dependent: :destroy
  has_many :algorithm_tasks, dependent: :destroy

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :registerable,
         :recoverable,
         :rememberable,
         :validatable


  def admin?
    roles.include?('admin')
  end

  after_initialize :set_default_roles, if: :new_record?

  def set_default_roles
    self.roles = ['basic'] if roles.blank?
  end

  # validates :email, presence: { message: 'Email должен быть указан!' },
  #           uniqueness: { message: 'Такой пользователь уже существует!' },
  #           format: { with: EMAIL_REGEX }
end
