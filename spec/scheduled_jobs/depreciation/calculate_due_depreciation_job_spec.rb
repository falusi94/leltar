# frozen_string_literal: true

RSpec.describe Depreciation::CalculateDueDepreciationJob do
  subject(:perform) { described_class.new.perform }

  it 'calls the depreciation logic' do
    allow(Depreciation).to receive(:calculate_due_depreciation)

    perform

    expect(Depreciation).to have_received(:calculate_due_depreciation)
  end
end
