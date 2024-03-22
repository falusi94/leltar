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
end
