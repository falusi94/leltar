# frozen_string_literal: true

# == Schema Information
#
# Table name: depreciation_details
#
#  id                           :bigint           not null, primary key
#  book_value                   :integer          not null
#  depreciation_frequency_unit  :string           not null
#  depreciation_frequency_value :integer          not null
#  depreciation_method          :string           not null
#  entry_date                   :date             not null
#  entry_value                  :integer          not null
#  salvage_value                :integer          not null
#  useful_life                  :integer          not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  item_id                      :bigint           not null
#
# Indexes
#
#  index_depreciation_details_on_item_id  (item_id)
#
# Foreign Keys
#
#  fk_rails_...  (item_id => items.id)
#

class DepreciationDetails < ApplicationRecord
  belongs_to :item

  validates :book_value, :depreciation_frequency_unit, :depreciation_frequency_value, :depreciation_method, :entry_date,
            :entry_value, :salvage_value, :useful_life, presence: true

  validates :depreciation_frequency_unit, inclusion: { in: DepreciationConfig.depreciation_frequency_units.values }
  validates :depreciation_method, inclusion: { in: DepreciationConfig.depreciation_methods.values }

  has_many :depreciation_entries, dependent: :destroy
  has_one :last_depreciation_entry, -> { by_calculation_desc },
          class_name: 'DepreciationEntry', dependent: false, inverse_of: false

  def depreciation_frequency
    depreciation_frequency_value.public_send(depreciation_frequency_unit)
  end

  def end_of_life?
    depreciation_entries.count == useful_life
  end
end
