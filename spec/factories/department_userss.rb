# frozen_string_literal: true

FactoryBot.define do
  factory :department_user do
    department
    user

    trait :write do
      write { true }
    end
  end

  factory :read_department_user, parent: :department_user
  factory :write_department_user, parent: :department_user, traits: %i[write]
end
