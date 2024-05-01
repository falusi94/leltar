# frozen_string_literal: true

RSpec.shared_context 'automatic depreciation enabled' do # rubocop:disable RSpec/ContextWording
  before do
    create(:automatic_depreciation_attribute)
    create(:automatic_depreciation_useful_life_attribute)
    create(:automatic_depreciation_salvage_value_attribute)
    create(:depreciation_method_attribute)
    create(:depreciation_frequency_unit_attribute)
    create(:depreciation_frequency_value_attribute)
  end
end
