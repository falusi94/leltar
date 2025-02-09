# frozen_string_literal: true

FactoryBot.define do
  factory :location do
    sequence(:name) { |i| "Location ##{i}" }

    organization
  end
end
