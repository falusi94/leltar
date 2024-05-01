# frozen_string_literal: true

module StringRefinements
  refine String do
    def to_boolean
      ActiveModel::Type::Boolean.new.cast(self)
    end
  end
end
