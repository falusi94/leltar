# frozen_string_literal: true

FactoryBot.define do
  factory :depreciation_entry do
    depreciation_details

    accumulated_depreciation { 10 }
    book_value { 10 }
    depreciation_expense { 10 }
    period_end_date { Time.zone.today }
    period_start_date { period_end_date - 1.year }
  end
end
