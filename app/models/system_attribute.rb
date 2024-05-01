# frozen_string_literal: true

# == Schema Information
#
# Table name: system_attributes
#
#  id    :integer          not null, primary key
#  name  :string           not null
#  value :string           not null
#
# Indexes
#
#  index_system_attributes_on_name  (name) UNIQUE
#

class SystemAttribute < ApplicationRecord
  using StringRefinements

  validates :name, :value, presence: true

  MAPPING = {
    new_session_start:                    :to_date,
    depreciation_method:                  :to_sym,
    depreciation_frequency_value:         :to_i,
    depreciation_frequency_unit:          :to_sym,
    automatic_depreciation:               :to_boolean,
    automatic_depreciation_useful_life:   :to_i,
    automatic_depreciation_salvage_value: :to_i
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

  def self.update!(attributes)
    ActiveRecord::Base.transaction do
      attributes.each do |key, value|
        next if ATTRIBUTES.exclude?(key.to_sym) || value.blank?

        SystemAttribute.find_or_initialize_by(name: key).update!(value: value)
      end
    end
  end
end
