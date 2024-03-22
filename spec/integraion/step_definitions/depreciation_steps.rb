# frozen_string_literal: true

steps_for :depreciation do
  attr_reader :item

  delegate :depreciation_details, to: :item

  step 'a setup' do
    create(:depreciation_method_attribute)
    create(:depreciation_frequency_unit_attribute)
    create(:depreciation_frequency_value_attribute)
  end

  step 'an item with entry value :entry_value' do |entry_value|
    @item = create(:item, entry_price: entry_value)
  end

  step 'travel :no_years year' do |no_years|
    travel(no_years.to_i.years)
  end

  step 'start depreciation with salvage value :salvage_value, useful life :useful_life' do |salvage_value, useful_life|
    Depreciation.init(item, params: { salvage_value: salvage_value, useful_life: useful_life })
  end

  step 'create depreciation details' do
    expect(item.reload.depreciation_details).to be_present
  end

  step 'calculate depreciation' do
    @depreciation_entry_before = DepreciationEntry.count

    Depreciation.calculate(item.depreciation_details)

    @depreciation_entry_after = DepreciationEntry.count
  end

  step 'create :no_entries depreciation entry' do |no_entries|
    expect(@depreciation_entry_after - @depreciation_entry_before).to eq(no_entries.to_i)
  end

  step 'last depreciation has accumulated depreciation :accumulated_depreciation, book value :book_value and ' \
       'depreciation expense :depreciation_expense' do |accumulated_depreciation, book_value, depreciation_expense|
    expect(depreciation_details.reload.last_depreciation_entry).to have_attributes(
      accumulated_depreciation: accumulated_depreciation.to_i,
      book_value:               book_value.to_i,
      depreciation_expense:     depreciation_expense.to_i
    )
  end

  step 'have book value :book_value' do |book_value|
    expect(depreciation_details.reload).to have_attributes(book_value: book_value.to_i)
  end
end
