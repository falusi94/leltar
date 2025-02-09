# frozen_string_literal: true

module ItemsQuery
  SEARCH_FIELDS = %i[
    items.name
    items.description
    items.status
    items.serial
    items.specific_name
    locations.name
    items.at_who
    items.condition
    items.inventory_number
  ].freeze

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
      .joins('LEFT OUTER JOIN locations ON locations.id = items.location_id')
      .by_department(filters[:department_id])
      .by_query(filters[:query])
  end
end
