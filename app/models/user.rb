class User < ApplicationRecord
  has_secure_password

  def can_read?(object)
    allowed = read_rights.split(' ')
    allowed.include?('all') || allowed.include?(object)
  end

  def can_write?(object)
    allowed = write_rights.split(' ')
    allowed.include?('all') || allowed.include?(object)
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
