# frozen_string_literal: true

FactoryBot.define do
  factory :depreciation_config do
    organization

    depreciation_method { :straight_line_depreciation }
    depreciation_frequency_unit { :year }
    depreciation_frequency_value { 1 }
    automatic_depreciation { false }
    automatic_depreciation_useful_life { 10 }
    automatic_depreciation_salvage_value { 0 }

    trait :with_automatic_depreciation do
      automatic_depreciation { true }
    end
  end
end
