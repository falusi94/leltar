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
#  last_organization_id :bigint
#
# Indexes
#
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_last_organization_id  (last_organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (last_organization_id => organizations.id)
#

class User < ApplicationRecord
  include Authentication::ModelMixin
  include UserAuthorization

  validates :email, :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :organization_users, dependent: :nullify
  has_many :organizations, through: :organization_users

  has_many :department_users, dependent: :nullify
  has_many :write_department_users, -> { write }, class_name: 'DepartmentUser', dependent: false, inverse_of: :user
  has_many :departments, through: :department_users do
    def with_read_access
      user = proxy_association.owner
      return Department.all if user.admin || user.read_all_department

      where(id: user.department_users.pluck(:department_id))
    end

    def with_write_access
      user = proxy_association.owner
      return Department.all if user.admin || user.write_all_department

      where(id: user.write_department_users.pluck(:department_id))
    end
  end

  has_many :sessions, class_name: 'UserSession', dependent: :destroy

  belongs_to :last_organization, class_name: 'Organization', optional: true

  def self.digest(string)
    cost = BCrypt::Engine::MIN_COST if ActiveModel::SecurePassword.min_cost
    cost ||= BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
