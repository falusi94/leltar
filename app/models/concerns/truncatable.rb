# frozen_string_literal: true

module Truncatable
  extend ActiveSupport::Concern

  included do
    def self.truncate_field_before_save(*args, length:)
      args.each do |name_of_field|
        before_save -> { truncate_field_to_fit_into_max_storage_size(name_of_field, length) }
      end
    end
  end

  def truncate_field_to_fit_into_max_storage_size(name_of_field, max_field_size_in_chars)
    content = send(name_of_field)
    return if content.blank?

    truncated_content = content.truncate_bytes(max_field_size_in_chars, omission: '')

    send(:"#{name_of_field}=", truncated_content)
  end
end
