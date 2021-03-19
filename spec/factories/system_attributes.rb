# frozen_string_literal: true

FactoryBot.define do
  factory :system_attribute do
    sequence(:name) { |i| "attribute name #{i}" }
    sequence(:value) { |i| "attribute value #{i}" }
  end
end
