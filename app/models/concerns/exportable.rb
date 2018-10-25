require 'csv'

module Exportable
  extend ActiveSupport::Concern

  module ClassMethods
    def to_csv(records = all, options = {})
      CSV.generate(options) do |csv|
        csv << column_names
        records.each do |record|
          csv << record.attributes.values
        end
      end
    end
  end
end
