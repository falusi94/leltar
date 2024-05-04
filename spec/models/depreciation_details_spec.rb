# frozen_string_literal: true

RSpec.describe DepreciationDetails do
  describe '#depreciation_frequency' do
    subject(:depreciation_frequency) { depreciation_details.depreciation_frequency }

    let(:depreciation_details) do
      build_stubbed(:depreciation_details, depreciation_frequency_value: 2, depreciation_frequency_unit: :weeks)
    end

    it { is_expected.to eq(2.weeks) }
  end
end
