# frozen_string_literal: true

FactoryBot.define do
  factory :right do
    group
    user

    trait :write do
      write { true }
    end
  end

  factory :read_right, parent: :right
  factory :write_right, parent: :right, traits: %i[write]
end
