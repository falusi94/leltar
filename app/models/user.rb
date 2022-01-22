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

  def can_read?(group_id)
    admin || read_all_group || rights.exists?(group_id: group_id)
  end

  def can_write?(group_id)
    admin || write_all_group || rights.write.exists?(group_id: group_id)
  end

  def can_edit_groups?
    admin || write_all_group || rights.any?(&:write)
  end

  def read_groups
    return Group.all if admin || read_all_group

    groups
  end

  def write_groups
    return Group.all if admin || write_all_group

    Group.select do |group|
      rights.any? { |right| right.group_id == group.id && right.write }
    end
  end

  def self.digest(string)
    cost = BCrypt::Engine::MIN_COST if ActiveModel::SecurePassword.min_cost
    cost ||= BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
