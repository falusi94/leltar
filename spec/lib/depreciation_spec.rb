# frozen_string_literal: true

RSpec.describe Depreciation do
  describe '.init' do
    it 'proxies the method to InitDepreciation' do
      allow(Depreciation::InitDepreciation).to receive(:call)

      params = ['item', { params: { useful_life: 1 } }]

      described_class.init(*params)

      expect(Depreciation::InitDepreciation).to have_received(:call).with(*params)
    end
  end

  describe '.calculate' do
    it 'proxies the method to CalculateDepreciation' do
      allow(Depreciation::CalculateDepreciation).to receive(:call)

      described_class.calculate('depreciation_details')

      expect(Depreciation::CalculateDepreciation).to have_received(:call).with('depreciation_details')
    end
  end

  describe '.calculate_due_depreciation' do
    subject(:calculate_due_depreciation) { described_class.calculate_due_depreciation }

    before { allow(described_class).to receive(:calculate).and_call_original }

    let!(:depreciation_details) { create(:depreciation_details, entry_date: entry_date) }

    context 'when there is no items' do
      let(:entry_date) { Time.current }

      it 'does nothing' do
        calculate_due_depreciation

        expect(described_class).not_to have_received(:calculate)
      end
    end

    context 'when there is nothing to calculate' do
      let(:entry_date) { 1.year.ago }

      it 'does nothing' do
        calculate_due_depreciation

        expect(described_class).to have_received(:calculate).with(depreciation_details)
      end
    end
  end
end
