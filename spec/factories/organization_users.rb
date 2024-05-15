# frozen_string_literal: true

FactoryBot.define do
  factory :organization_user do
    organization
    user

    trait :observer do
      role_name { 'observer' }
    end

    trait :admin do
      role_name { 'admin' }
    end
  end
end
