# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    sequence(:name) { |i| "Item #{i}" }
    description { 'Item description' }
    group { build(:group) }
    purchase_date { 3.days.ago }
    entry_date { 2.days.ago }
    last_check { 1.days.ago }
    status { :ok }

    trait :with_parent do
      parent { build(:item, group: group) }
    end

    trait :with_child do
      after(:create) do |item|
        create(:item, parent: item, group: item.group)
      end
    end
  end
end
