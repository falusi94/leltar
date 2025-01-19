# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:email) { |i| "user-#{i}@example.org" }

    name { 'User Name' }
    password { 'password' }
    password_confirmation { 'password' }

    trait :admin do
      admin { true }
    end

    trait :with_session do
      sessions { build_list(:user_session, 1) }
    end

    trait :with_last_organization do
      last_organization { association(:organization) }
    end
  end

  factory :admin, parent: :user, traits: [:admin]
end
