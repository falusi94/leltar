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
end
