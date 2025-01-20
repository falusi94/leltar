# frozen_string_literal: true

# == Schema Information
#
# Table name: depreciation_configs
#
#  id                                   :bigint           not null, primary key
#  automatic_depreciation               :boolean          not null
#  automatic_depreciation_salvage_value :integer          not null
#  automatic_depreciation_useful_life   :integer          not null
#  depreciation_frequency_unit          :string           not null
#  depreciation_frequency_value         :integer          not null
#  depreciation_method                  :string           not null
#  created_at                           :datetime         not null
#  updated_at                           :datetime         not null
#  organization_id                      :bigint           not null
#
# Indexes
#
#  index_depreciation_configs_on_organization_id  (organization_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

class DepreciationConfig < ApplicationRecord
  belongs_to :organization

  validates :depreciation_method, :depreciation_frequency_value, :depreciation_frequency_unit,
            :automatic_depreciation_useful_life, :automatic_depreciation_salvage_value, presence: true
  validates :automatic_depreciation, inclusion: { in: [true, false] }

  enum depreciation_method: {
    straight_line_depreciation: 'straight_line_depreciation'
  }

  enum depreciation_frequency_unit: {
    day:   'day',
    week:  'week',
    month: 'month',
    year:  'year'
  }
end
