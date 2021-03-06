# frozen_string_literal: true

FactoryBot.define do
  factory :group do
    sequence(:name) { |i| "Group ##{i}" }
  end
end
