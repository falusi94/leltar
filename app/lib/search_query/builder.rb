# frozen_string_literal: true

module SearchQuery
  class Builder
    DEFAULT_COUNT = Pagy::DEFAULT[:items]

    attr_reader :query_string, :scope, :fields, :offset, :count

    def self.run(...)
      new(...).perform
    end

    def initialize(query_string, scope:, fields:, transliterate: true, **options) # rubocop:disable Metrics/MethodLength
      @query_string = if transliterate
                        I18n.transliterate(query_string)
                      else
                        query_string
                      end
      @scope        = scope
      @fields       = fields
      @count        = options[:count] || DEFAULT_COUNT
      @offset       = if options[:offset]
                        options[:offset]
                      elsif options[:page]
                        (options[:page] - 1) * count
                      else
                        0
                      end
    end

    def perform
      result = scope.where(query, *params).offset(offset)

      count.negative? ? result : result.limit(count)
    end

    private

    # Create an array including each keyword the times of the number of fields
    # Each keyword is converted into lowercase and wrapped between %
    # For example:
    #   ['%keyword1%', '%keyword1%', '%keyword2%', '%keyword2%']

    def params
      split_query_string.flat_map do |keyword|
        ["%#{keyword}%".mb_chars.downcase.to_s] * query_for_one_keyword.count('?')
      end
    end

    def split_query_string
      @split_query_string ||= query_string.split
    end

    # Concatenate the search query for each keywords by AND
    # For example:
    #   (query_for_one_keyword) AND (query_for_one_keyword)

    def query
      ([query_for_one_keyword] * split_query_string.size).join(' AND ')
    end

    # Create search query for all fields by a keyword
    # For example:
    #   (lower(field1) LIKE ? OR lower(field2) LIKE ?)

    def query_for_one_keyword
      return @query_for_one_keyword if @query_for_one_keyword

      query = fields.map { |field| "lower(#{field}) LIKE ?" }
                    .join(' OR ')
      @query_for_one_keyword = "(#{query})"
    end
  end
end
