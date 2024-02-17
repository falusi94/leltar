# frozen_string_literal: true

FactoryBot.define do
  factory :user_session do
    ip_address { 'ip_address' }
    last_used  { Time.zone.now }
    user_agent { 'user_agent' }
    client_id  { SecureRandom.uuid }
  end
end
