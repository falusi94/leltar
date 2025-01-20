# frozen_string_literal: true

module Depreciation
  class InitDepreciation
    def initialize(item, params:)
      @item = item
      @params = params
    end

    def self.call(...)
      new(...).call
    end

    def call
      create_depreciation_details
      calculate_depreciation

      depreciation_details
    end

    private

    def create_depreciation_details
      @depreciation_details = DepreciationDetails.create!(
        item:                         item,
        depreciation_method:          depreciation_method,
        depreciation_frequency_unit:  depreciation_frequency_unit,
        depreciation_frequency_value: depreciation_frequency_value,
        entry_date:                   item.entry_date,
        entry_value:                  item.entry_price,
        book_value:                   item.entry_price,
        **params.slice(:salvage_value, :useful_life)
      )
    end

    def calculate_depreciation
      Depreciation.calculate(depreciation_details)
    end

    delegate :depreciation_method, :depreciation_frequency_unit, :depreciation_frequency_value, to: :depreciation_config

    def depreciation_config
      item.organization.safe_depreciation_config
    end

    attr_reader :item, :params, :depreciation_details
  end
end
