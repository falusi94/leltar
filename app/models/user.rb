class User < ApplicationRecord
  has_secure_password
  has_many :rights
  has_many :groups, through: :rights

  def can_read?(group_id)
    return true if admin
    return true if rights.any? { |right| right.group.id == group_id }
    false
  end

  def can_write?(group_id)
    return true if admin
    return true if rights.any? { |right| right.group.id == group_id && right.write }
    false
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
