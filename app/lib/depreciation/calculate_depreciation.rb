# frozen_string_literal: true

module Depreciation
  class CalculateDepreciation
    def initialize(depreciation_details)
      @depreciation_details = depreciation_details
    end

    def self.call(...)
      new(...).call
    end

    def call
      depreciation_method_class.call(depreciation_details) while new_depreciation? && !depreciation_details.end_of_life?
    end

    private

    def new_depreciation?
      last_depreciation + depreciation_details.depreciation_frequency < Time.zone.now
    end

    def last_depreciation
      last_depreciation_entry.present? ? last_depreciation_entry.period_end_date : depreciation_details.entry_date
    end

    def last_depreciation_entry
      depreciation_details.reload.last_depreciation_entry
    end

    def depreciation_method_class
      "Depreciation::Methods::#{depreciation_details.depreciation_method.camelize}".constantize
    end

    attr_reader :depreciation_details
  end
end
