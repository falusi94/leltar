# frozen_string_literal: true

FactoryBot.define do
  factory :department do
    sequence(:name) { |i| "Department ##{i}" }

    trait :with_organization do
      organization
    end
  end
end
