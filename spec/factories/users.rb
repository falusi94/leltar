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

    trait :write_all_group do
      write_all_group { true }
      read_all_group { true }
    end

    trait :read_all_group do
      read_all_group { true }
    end
  end

  factory :admin, parent: :user, traits: [:admin]
end
