# frozen_string_literal: true

module Depreciation
  def self.init(...)
    InitDepreciation.call(...)
  end

  def self.calculate(...)
    CalculateDepreciation.call(...)
  end
end
