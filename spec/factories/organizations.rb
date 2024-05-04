# frozen_string_literal: true

FactoryBot.define do
  factory :organization do
    sequence(:name) { |i| "Organization ##{i}" }
    currency_code { 'EUR' }
    sequence(:slug) { |i| "organization-#{i}" }
  end
end
