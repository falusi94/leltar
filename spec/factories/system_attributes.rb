# frozen_string_literal: true

FactoryBot.define do
  factory :system_attribute do
    sequence(:name) { SystemAttribute::ATTRIBUTES.first }
    sequence(:value) { |i| "attribute value #{i}" }
  end

  factory :new_session_start_attribute, parent: :system_attribute do
    name { :new_session_start }
    value { Time.zone.today.to_s }
  end

  factory :depreciation_method_attribute, parent: :system_attribute do
    name { :depreciation_method }
    value { :straight_line_depreciation }
  end

  factory :depreciation_frequency_unit_attribute, parent: :system_attribute do
    name { :depreciation_frequency_unit }
    value { :year }
  end

  factory :depreciation_frequency_value_attribute, parent: :system_attribute do
    name { :depreciation_frequency_value }
    value { 1 }
  end
end
