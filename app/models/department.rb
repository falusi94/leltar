# frozen_string_literal: true

# == Schema Information
#
# Table name: departments
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_departments_on_name  (name) UNIQUE
#

class Department < ApplicationRecord
  validates :name, uniqueness: true, presence: true

  has_many :items, dependent: :nullify
  has_many :department_users, dependent: :destroy
  has_many :users, through: :department_users
end
