# frozen_string_literal: true

describe Depreciation::CalculateDepreciation do
  subject(:calculate_depreciation) { described_class.call(depreciation_details) }

  let(:depreciation_details) { create(:depreciation_details) }

  before { allow(Depreciation::Methods::StraightLineDepreciation).to receive(:call).and_call_original }

  context 'when there is a missing depreciation entry' do
    before { travel(depreciation_details.depreciation_frequency) }

    it 'calls the depreciation method' do
      calculate_depreciation

      expect(Depreciation::Methods::StraightLineDepreciation).to have_received(:call).with(depreciation_details)
    end

    context 'and the it is already depreciated' do
      before { allow(depreciation_details).to receive(:end_of_life?).and_return(true) }

      it 'does nothing' do
        calculate_depreciation

        expect(Depreciation::Methods::StraightLineDepreciation).not_to have_received(:call)
      end
    end
  end

  context 'when there are missing depreciation entries' do
    before { travel(2 * depreciation_details.depreciation_frequency) }

    it 'calls the depreciation method many times' do
      calculate_depreciation

      expect(Depreciation::Methods::StraightLineDepreciation).to have_received(:call).with(depreciation_details).twice
    end
  end

  context 'when there is no missing depreciation entry' do
    it 'does nothing' do
      calculate_depreciation

      expect(Depreciation::Methods::StraightLineDepreciation).not_to have_received(:call)
    end
  end
end
