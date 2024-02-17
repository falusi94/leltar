# frozen_string_literal: true

# == Schema Information
#
# Table name: user_sessions
#
#  id         :bigint           not null, primary key
#  ip_address :string
#  last_used  :datetime         not null
#  user_agent :string(512)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  client_id  :string
#  user_id    :bigint           not null
#
# Indexes
#
#  index_user_sessions_on_client_id  (client_id)
#  index_user_sessions_on_user_id    (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#

class UserSession < ApplicationRecord
  include Truncatable

  belongs_to :user

  truncate_field_before_save :user_agent, length: 512
end
