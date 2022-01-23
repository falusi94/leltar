# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  admin           :boolean
#  email           :string
#  name            :string
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
  has_secure_password
  has_many :rights
  has_many :groups, through: :rights
  has_many :write_rights, -> { write }, class_name: 'Right'

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
