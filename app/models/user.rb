# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  admin           :boolean          default(FALSE)
#  email           :string           not null
#  last_sign_in_at :datetime
#  name            :string           not null
#  password_digest :string
#  read_all_group  :boolean          default(FALSE)
#  write_all_group :boolean          default(FALSE)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ApplicationRecord
  include Authentication::ModelMixin

  validates :email, :name, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  has_many :rights, dependent: :nullify
  has_many :groups, through: :rights
  has_many :write_rights, -> { write }, class_name: 'Right', dependent: false, inverse_of: :user
  has_many :sessions, class_name: 'UserSession', dependent: :destroy

  def read_groups
    return Group.all if admin || read_all_group

    groups
  end

  def write_groups
    return Group.all if admin || write_all_group

    groups.where(id: write_rights.pluck(:group_id))
  end

  def self.digest(string)
    cost = BCrypt::Engine::MIN_COST if ActiveModel::SecurePassword.min_cost
    cost ||= BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
