# frozen_string_literal: true

FactoryBot.define do
  factory :item do
    sequence(:name) { |i| "Item #{i}" }
    description { 'Item description' }
    purchase_date { 3.days.ago }
    entry_date { 2.days.ago }
    last_check { 1.day.ago }
    status { :ok }

    department

    trait :with_parent do
      parent { association(:item, department: department) }
    end

    trait :with_child do
      after(:create) do |item|
        create(:item, parent: item, department: item.department)
      end
    end

    trait :with_invoice do
      after(:build) do |item|
        file = File.open('spec/fixtures/files/dot.jpg')
        item.invoice.attach(io: file, filename: 'dot.jpg', content_type: 'image/jpeg')
      end
    end

    trait :with_photo do
      after(:build) do |item|
        file = File.open('spec/fixtures/files/dot.jpg')
        item.photos.attach(io: file, filename: 'dot.jpg', content_type: 'image/jpeg')
      end
    end
  end
end
