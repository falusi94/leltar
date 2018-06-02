class Group < ApplicationRecord
  searchkick

  validates :name, uniqueness: true
  has_many :items
  has_many :rights

  def self.by_name(name)
    Group.where(name: name).first
  end

  def self.exists?(name)
    !Group.where(name: name).empty?
  end

  def Group.can_read(user_id)
    Group.select do |group|
      group.rights.any? { |right| right.user_id == user_id }
    end
  end

  def Group.can_write(user_id)
    Group.select do |group|
      group.rights.any? { |right| right.user_id == user_id && right.write }
    end
  end
end
