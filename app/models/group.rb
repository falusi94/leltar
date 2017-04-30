class Group < ApplicationRecord
  validates :name, uniqueness: true
  has_many :items

  def self.by_name(name)
    Group.where(name: name).first
  end

  def self.exists?(name)
    !Group.where(name: name).empty?
  end
end
