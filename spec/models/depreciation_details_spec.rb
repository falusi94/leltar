# frozen_string_literal: true

RSpec.describe DepreciationDetails do
  describe '#last_depreciation_entry' do
    subject(:last_depreciation_entry) { depreciation_details.last_depreciation_entry }

    let(:depreciation_details) { create(:depreciation_details) }
    let!(:entries) do
      [
        create(:depreciation_entry, period_end_date: 1.year.ago, depreciation_details: depreciation_details),
        create(:depreciation_entry, period_end_date: Time.zone.today, depreciation_details: depreciation_details)
      ]
    end

    it { is_expected.to eq(entries.last) }
  end

  describe '#depreciation_frequency' do
    subject(:depreciation_frequency) { depreciation_details.depreciation_frequency }

    let(:depreciation_details) do
      build_stubbed(:depreciation_details, depreciation_frequency_value: 2, depreciation_frequency_unit: :weeks)
    end

    it { is_expected.to eq(2.weeks) }
  end

  describe '#end_of_life?' do
    subject(:end_of_life?) { depreciation_details.end_of_life? }

    context 'when there are less entries than the useful life' do
      let(:depreciation_details) { create(:depreciation_details, useful_life: 1) }

      it { is_expected.to be(false) }
    end

    context 'when the number of entries equals the useful life' do
      let(:depreciation_details) { create(:depreciation_details, useful_life: 0) }

      it { is_expected.to be(true) }
    end
  end
end
