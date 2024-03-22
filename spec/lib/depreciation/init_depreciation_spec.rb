# frozen_string_literal: true

describe Depreciation::InitDepreciation do
  subject(:init_depreciation) { Depreciation.init(item, params: params) }

  let(:item) { create(:item) }
  let(:params) { { salvage_value: 0, useful_life: 7 } }

  let!(:depreciation_method_attribute) { create(:depreciation_method_attribute) }
  let!(:depreciation_frequency_unit_attribute) { create(:depreciation_frequency_unit_attribute) }
  let!(:depreciation_frequency_value_attribute) { create(:depreciation_frequency_value_attribute) }

  before { allow(Depreciation).to receive(:calculate) }

  it 'creates depreciation details' do
    expect { init_depreciation }.to change(DepreciationDetails, :count).by(1)

    expect(DepreciationDetails.last).to have_attributes(
      item:                         item,
      depreciation_method:          depreciation_method_attribute.value,
      depreciation_frequency_unit:  depreciation_frequency_unit_attribute.value,
      depreciation_frequency_value: depreciation_frequency_value_attribute.value.to_i,
      entry_date:                   item.entry_date,
      entry_value:                  item.entry_price,
      book_value:                   item.entry_price,
      salvage_value:                0,
      useful_life:                  7
    )
  end

  it 'calculates depreciation' do
    init_depreciation

    expect(Depreciation).to have_received(:calculate).with(item.depreciation_details)
  end
end
