# frozen_string_literal: true

module ItemsQuery
  SEARCH_FIELDS = %i[name description status serial specific_name location at_who condition inventory_number].freeze

  module Scopes
    def by_department(department_id)
      department_id.present? ? where(department_id: department_id) : self
    end

    def by_query(query)
      query.present? ? includes(:department).search(query, fields: SEARCH_FIELDS, count: -1) : self
    end
  end

  def self.fetch(filters, scope: Item)
    scope
      .extending(Scopes)
      .by_department(filters[:department_id])
      .by_query(filters[:query])
  end
end
