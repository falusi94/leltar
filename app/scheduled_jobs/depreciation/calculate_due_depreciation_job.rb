# frozen_string_literal: true

module Depreciation
  class CalculateDueDepreciationJob < ScheduledJob
    def perform
      Depreciation.calculate_due_depreciation
    end
  end
end
