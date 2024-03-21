# frozen_string_literal: true

FactoryBot.define do
  factory :department do
    sequence(:name) { |i| "Department ##{i}" }
  end
end
