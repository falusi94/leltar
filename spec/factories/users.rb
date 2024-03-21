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

    trait :write_all_department do
      write_all_department { true }
      read_all_department { true }
    end

    trait :read_all_department do
      read_all_department { true }
    end

    trait :with_session do
      sessions { build_list(:user_session, 1) }
    end
  end

  factory :admin, parent: :user, traits: [:admin]
end
