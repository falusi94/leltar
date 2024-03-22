# frozen_string_literal: true

module Depreciation
  module Methods
    class StraightLineDepreciation
      def initialize(depreciation_details)
        @depreciation_details = depreciation_details
      end

      def self.call(...)
        new(...).call
      end

      def call
        ActiveRecord::Base.transaction do
          create_depreciation_entry
          update_depreciation_details
        end
      end

      private

      def create_depreciation_entry
        DepreciationEntry.create!(
          depreciation_details:     depreciation_details,
          accumulated_depreciation: accumulated_depreciation,
          book_value:               book_value,
          depreciation_expense:     depreciation_expense,
          period_start_date:        last_depreciation_entry.period_end_date,
          period_end_date:          period_end_date
        )
      end

      def update_depreciation_details
        depreciation_details.update!(book_value: book_value)
      end

      def accumulated_depreciation
        last_depreciation_entry.accumulated_depreciation + depreciation_expense
      end

      def book_value
        last_depreciation_entry.book_value - depreciation_expense
      end

      def period_end_date
        last_depreciation_entry.period_end_date + depreciation_details.depreciation_frequency
      end

      def depreciation_expense
        value_change = depreciation_details.entry_value - depreciation_details.salvage_value

        (value_change / depreciation_details.useful_life.to_f).round
      end

      def last_depreciation_entry
        @last_depreciation_entry ||= depreciation_details.last_depreciation_entry || initial_depreciation_entry
      end

      def initial_depreciation_entry
        DepreciationEntry.new(
          book_value:               depreciation_details.entry_value,
          accumulated_depreciation: 0,
          period_end_date:          depreciation_details.entry_date
        )
      end

      attr_reader :depreciation_details
    end
  end
end
