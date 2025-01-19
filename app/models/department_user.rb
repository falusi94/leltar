# frozen_string_literal: true

# == Schema Information
#
# Table name: department_users
#
#  id            :integer          not null, primary key
#  write         :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :integer          not null
#  user_id       :integer          not null
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (user_id => users.id)
#

class DepartmentUser < ApplicationRecord
  belongs_to :user
  belongs_to :department

  has_one :organization, through: :department

  scope :write, -> { where(write: true) }
end
