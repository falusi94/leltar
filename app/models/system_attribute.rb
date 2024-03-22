# frozen_string_literal: true

# == Schema Information
#
# Table name: system_attributes
#
#  id    :integer          not null, primary key
#  name  :string
#  value :string
#
# Indexes
#
#  index_system_attributes_on_name  (name) UNIQUE
#

class SystemAttribute < ApplicationRecord
  MAPPING = {
    new_session_start: :to_date
  }.freeze

  ATTRIBUTES = MAPPING.keys

  class << self
    MAPPING.each do |name, transformer|
      define_method name do
        find_by!(name: name).value.public_send(transformer)
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end
  end
end
