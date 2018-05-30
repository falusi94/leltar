class User < ApplicationRecord
  has_secure_password
  has_many :rights

  def can_read?(object)
    return true if admin
    return true if rights.any? { |right| right.group.id == object }
    false
  end

  def can_write?(object)
    return true if admin
    return true if rights.any? { |right| right.group.id == object && right.write }
    false
  end

  def read_groups
    allowed = read_rights.split(' ')
    groups = []
    re = /^group:(.+)$/
    allowed.each do |str|
      match = re.match(str)
      if match
        groups.push(match[1])
      end
    end
    groups
  end

  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end
