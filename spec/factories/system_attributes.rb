# frozen_string_literal: true

FactoryBot.define do
  factory :system_attribute do
    sequence(:name) { |i| "attribute name #{i}" }
    sequence(:value) { |i| "attribute value #{i}" }
  end

  factory :new_session_start_attribute, parent: :system_attribute do
    name { :new_session_start }
    value { Time.zone.today.to_s }
  end
end
