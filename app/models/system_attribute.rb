class SystemAttribute < ApplicationRecord
  def self.new_session_start
    value = where(name: :new_session_start).first&.value
    Chronic.parse value
  end
end
