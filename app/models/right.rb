# frozen_string_literal: true

# == Schema Information
#
# Table name: rights
#
#  id            :integer          not null, primary key
#  write         :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :integer
#  user_id       :integer
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (user_id => users.id)
#

class Right < ApplicationRecord
  belongs_to :user
  belongs_to :department

  scope :write, -> { where(write: true) }
end
