# frozen_string_literal: true

RSpec.describe Organization do
  describe '#safe_depreciation_config' do
    subject(:safe_depreciation_config) { organization.safe_depreciation_config }

    context 'when the organization has no depreciation config' do
      let(:organization) { build_stubbed(:organization) }

      it 'returns a new one' do
        expect(safe_depreciation_config).to be_present.and have_attributes(
          automatic_depreciation:               false,
          automatic_depreciation_salvage_value: 0,
          automatic_depreciation_useful_life:   10,
          depreciation_frequency_unit:          'year',
          depreciation_frequency_value:         1,
          depreciation_method:                  'straight_line_depreciation',
          organization:                         organization
        )
        expect(safe_depreciation_config).not_to be_persisted
      end
    end

    context 'when the organization has depreciation config' do
      let(:organization) { create(:organization, :with_depreciation_config) }

      it 'returns a saved one one' do
        expect(safe_depreciation_config).to be_present.and be_persisted
      end
    end
  end
end
