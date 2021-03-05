# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:id)

    name { 'User Name' }
    email { 'user@example.org' }
    password { 'password' }
    password_confirmation { 'password' }

    trait :admin do
      admin { true }
    end
  end

  factory :admin, parent: :user, traits: [:admin]
end
