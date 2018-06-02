class Group < ApplicationRecord
  searchkick

  validates :name, uniqueness: true
  has_many :items
  has_many :rights

end
