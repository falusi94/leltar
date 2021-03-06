# == Schema Information
#
# Table name: rights
#
#  id         :integer          not null, primary key
#  write      :boolean
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  group_id   :integer
#  user_id    :integer
#

class Right < ApplicationRecord
  belongs_to :user
  belongs_to :group
end
