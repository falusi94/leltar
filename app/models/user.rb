# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                   :integer          not null, primary key
#  admin                :boolean          default(FALSE)
#  email                :string           not null
#  last_sign_in_at      :datetime
#  name                 :string           not null
#  password_digest      :string
#  read_all_department  :boolean          default(FALSE)
#  write_all_department :boolean          default(FALSE)
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ApplicationRecord
  include Authentication::ModelMixin

  validates :email, :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :organization_users, dependent: :nullify
  has_many :organizations, through: :organization_users

  has_many :department_users, dependent: :nullify
  has_many :departments, through: :department_users
  has_many :write_department_users, -> { write }, class_name: 'DepartmentUser', dependent: false, inverse_of: :user

  has_many :sessions, class_name: 'UserSession', dependent: :destroy

  def read_departments
    return Department.all if admin || read_all_department

    departments
  end

  def write_departments
    return Department.all if admin || write_all_department

    departments.where(id: write_department_users.pluck(:department_id))
  end

  def self.digest(string)
    cost = BCrypt::Engine::MIN_COST if ActiveModel::SecurePassword.min_cost
    cost ||= BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
