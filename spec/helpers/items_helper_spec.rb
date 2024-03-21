# frozen_string_literal: true

describe ItemsHelper do
  let(:test_class) do
    Class.new do
      include ItemsHelper
    end
  end

  describe '#parent_item_candidates' do
    subject(:parent_item_candidates) { test_class.new.parent_item_candidates(item) }

    context 'when there is no item' do
      let(:item) { nil }

      it 'returns all items without parent' do
        item_without_parent = create(:item)
        item_with_parent    = create(:item, :with_parent)

        expect(parent_item_candidates).to match([item_without_parent, item_with_parent.parent])
      end
    end

    context 'when there is an item' do
      let(:item) { create(:item) }

      it 'returns items without parent in the same department' do
        item_of_the_same_department = create(:item, department: item.department)
        _item_of_another_department = create(:item)

        expect(parent_item_candidates).to match([item, item_of_the_same_department])
      end
    end
  end

  describe '#items_page_title' do
    subject(:items_page_title) { test_class.new.items_page_title(department) }

    context 'when there is a department' do
      let(:department) { build(:department, name: 'Department') }

      it { is_expected.to eq('Item(s) of Department') }
    end

    context 'when there is no department' do
      let(:department) { nil }

      it { is_expected.to eq('Item(s)') }
    end
  end
end
