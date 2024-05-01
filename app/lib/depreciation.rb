# frozen_string_literal: true

module Depreciation
  def self.init(...)
    InitDepreciation.call(...)
  end

  def self.calculate(...)
    CalculateDepreciation.call(...)
  end

  def self.calculate_due_depreciation
    DepreciationDetails.extending(Scopes::DepreciationDetailsScopes).due.find_each do |depreciation_details|
      calculate(depreciation_details)
    end
  end
end
