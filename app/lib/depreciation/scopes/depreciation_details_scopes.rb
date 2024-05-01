# frozen_string_literal: true

module Depreciation
  module Scopes
    module DepreciationDetailsScopes
      extend Scopeable

      scope :due, lambda {
        join_table = <<~JOIN_TABLE.squish
          select max(period_end_date) as maximum_period_end_date, depreciation_details_id
          from depreciation_entries
          group by depreciation_details_id
        JOIN_TABLE

        last_entry_query = <<~QUERY.squish
          now() - (concat_ws(' ', depreciation_frequency_value, depreciation_frequency_unit))::interval
        QUERY

        where_caluse = <<~QUERY.squish
          (maximum_period_end_date is null and entry_date < (#{last_entry_query}))
            or (maximum_period_end_date is not null and maximum_period_end_date < (#{last_entry_query}))
        QUERY

        joins("left outer join (#{join_table}) m on m.depreciation_details_id = depreciation_details.id")
          .where(where_caluse)
      }
    end
  end
end
