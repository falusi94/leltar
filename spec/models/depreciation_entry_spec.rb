# frozen_string_literal: true

describe DepreciationEntry do
  describe '.by_calculation_desc' do
    subject(:scope) { described_class.by_calculation_desc }

    let(:depreciation_details) { create(:depreciation_details) }
    let!(:first_entry) do
      create(:depreciation_entry, period_end_date: 1.year.ago, depreciation_details: depreciation_details)
    end
    let!(:last_entry) do
      create(:depreciation_entry, period_end_date: Time.zone.today, depreciation_details: depreciation_details)
    end

    it { is_expected.to eq([last_entry, first_entry]) }
  end
end
