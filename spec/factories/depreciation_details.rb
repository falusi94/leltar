# frozen_string_literal: true

FactoryBot.define do
  factory :depreciation_details do
    item

    book_value { item.entry_price }
    depreciation_method { 'straight_line_depreciation' }
    depreciation_frequency_unit { 'year' }
    depreciation_frequency_value { 1 }
    entry_date { item.entry_date }
    entry_value { item.entry_price }
    salvage_value { 0 }
    useful_life { 7 }
  end
end
