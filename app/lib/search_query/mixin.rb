# frozen_string_literal: true

module SearchQuery
  module Mixin
    def search(query_string, **options)
      fields   = options[:fields]
      fields ||= columns.map(&:name)

      Builder.run(query_string, scope: self, fields: fields, **options)
    end
  end
end
