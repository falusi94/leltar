# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Group < ApplicationRecord
  validates :name, uniqueness: true

  has_many :items
  has_many :rights
  has_many :users, through: :rights
end
