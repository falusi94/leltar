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
# Foreign Keys
#
#  fk_rails_...  (group_id => groups.id)
#  fk_rails_...  (user_id => users.id)
#

class Right < ApplicationRecord
  belongs_to :user
  belongs_to :group

  scope :write, -> { where(write: true) }
end
