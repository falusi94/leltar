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

    trait :with_depreciation_entry do
      depreciation_entries do
        depreciation_expense = ((entry_value - salvage_value) / useful_life.to_f).round
        entry = association(
          :depreciation_entry,
          book_value:               book_value - depreciation_expense,
          period_start_date:        entry_date,
          period_end_date:          entry_date + depreciation_frequency_value.public_send(depreciation_frequency_unit),
          accumulated_depreciation: depreciation_expense,
          depreciation_expense:     depreciation_expense
        )
        [entry]
      end
    end
  end
end
