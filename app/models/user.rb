class User < ApplicationRecord
  has_secure_password
  has_many :rights
  has_many :groups, through: :rights

  def can_read?(group_id)
    return true if admin
    return true if rights.any? { |right| right.group_id.nil? }
    return true if rights.any? { |right| right.group_id == group_id }
    false
  end

  def can_write?(group_id)
    return true if admin
    return true if rights.any? { |right| right.group_id.nil? && right.write }
    return true if rights.any? { |right| right.group_id == group_id && right.write }
    false
  end

  def can_edit_groups?
    return true if admin
    return true if rights.any? { |right| right.write }
    false
  end

  def read_groups
    return Group.all if admin
    return Group.all if rights.any? { |right| right.group_id.nil? }
    groups
  end

  def write_groups
    return Group.all if admin
    return Group.all if rights.any? { |right| right.group_id.nil? && right.write }
    Group.select do |group|
      rights.any? { |right| right.group_id == group.id && right.write }
    end
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
