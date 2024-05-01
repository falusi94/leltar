# frozen_string_literal: true

RSpec.describe Depreciation::Scopes::DepreciationDetailsScopes do
  let(:klass) { DepreciationDetails.extending(described_class) }

  describe '#due' do
    subject(:scope) { klass.due }

    context 'when there is no depreciation details' do
      it { is_expected.to be_empty }
    end

    %i[day week month year].each do |frequency_unit|
      context "when the frequency unit is #{frequency_unit}" do
        let!(:depreciation_details) { create(:depreciation_details, depreciation_frequency_unit: frequency_unit) }

        context 'and the depreciation details has no depreciation entry' do
          context 'and the entry date is recent' do
            before { depreciation_details.update(entry_date: depreciation_details.depreciation_frequency.ago + 1.day) }

            it { is_expected.to be_empty }
          end

          context 'and there is enough time passed since the entry date' do
            before { depreciation_details.update(entry_date: depreciation_details.depreciation_frequency.ago) }

            it { is_expected.to contain_exactly(depreciation_details) }
          end
        end

        context 'and the depreciation details has a depreciation entry' do
          before do
            create(:depreciation_entry, depreciation_details: depreciation_details, period_end_date: period_end_date)
          end

          context 'and there is a recent depreciation entry' do
            let(:period_end_date) { depreciation_details.depreciation_frequency.ago + 1.day }

            it { is_expected.to be_empty }
          end

          context 'and there is an old depreciation entry' do
            let(:period_end_date) { depreciation_details.depreciation_frequency.ago }

            it { is_expected.to contain_exactly(depreciation_details) }
          end
        end
      end
    end
  end
end
