# frozen_string_literal: true

# == Schema Information
#
# Table name: depreciation_entries
#
#  id                       :bigint           not null, primary key
#  accumulated_depreciation :integer          not null
#  book_value               :integer          not null
#  depreciation_expense     :integer          not null
#  period_end_date          :date             not null
#  period_start_date        :date             not null
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  depreciation_details_id  :bigint           not null
#
# Indexes
#
#  index_depreciation_entries_on_depreciation_details_id  (depreciation_details_id)
#
# Foreign Keys
#
#  fk_rails_...  (depreciation_details_id => depreciation_details.id)
#

class DepreciationEntry < ApplicationRecord
  belongs_to :depreciation_details

  validates :accumulated_depreciation, :book_value, :depreciation_expense, :period_end_date, :period_start_date,
            presence: true

  scope :by_calculation_desc, -> { order(period_end_date: :desc) }
end
