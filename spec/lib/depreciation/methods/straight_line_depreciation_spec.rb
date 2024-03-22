# frozen_string_literal: true

describe Depreciation::Methods::StraightLineDepreciation do
  subject(:calculate) { described_class.call(depreciation_details) }

  let(:depreciation_expense) do
    value_change = depreciation_details.entry_value - depreciation_details.salvage_value

    (value_change / depreciation_details.useful_life.to_f).round
  end

  context 'when there is no depreciation entry' do
    let!(:depreciation_details) { create(:depreciation_details) }

    it 'creates one' do
      expect { calculate }.to change(DepreciationEntry, :count).by(1)

      expect(DepreciationEntry.last).to have_attributes(
        depreciation_details:     depreciation_details,
        accumulated_depreciation: depreciation_expense,
        book_value:               depreciation_details.entry_value - depreciation_expense,
        depreciation_expense:     depreciation_expense,
        period_start_date:        depreciation_details.entry_date,
        period_end_date:          depreciation_details.entry_date + depreciation_details.depreciation_frequency
      )
    end

    it 'updates the book value' do
      calculate

      expect(depreciation_details.reload)
        .to have_attributes(book_value: depreciation_details.entry_value - depreciation_expense)
    end
  end

  context 'when there is a depreciation entry' do
    let!(:depreciation_details) { create(:depreciation_details, :with_depreciation_entry) }

    it 'creates new one' do
      expect { calculate }.to change(DepreciationEntry, :count).by(1)

      expect(DepreciationEntry.last).to have_attributes(
        depreciation_details:     depreciation_details,
        accumulated_depreciation: 2 * depreciation_expense,
        book_value:               depreciation_details.entry_value - (2 * depreciation_expense),
        depreciation_expense:     depreciation_expense,
        period_start_date:        depreciation_details.entry_date + depreciation_details.depreciation_frequency,
        period_end_date:          depreciation_details.entry_date + (2 * depreciation_details.depreciation_frequency)
      )
    end

    it 'updates the book value' do
      calculate

      expect(depreciation_details.reload)
        .to have_attributes(book_value: depreciation_details.entry_value - (2 * depreciation_expense))
    end
  end
end
