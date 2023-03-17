# frozen_string_literal: true

describe ItemsHelper do
  let(:test_class) do
    Class.new do
      include ItemsHelper

      def initialize(item: nil, group: nil)
        @item  = item
        @group = group
      end
    end
  end

  describe '#parent_item_candidates' do
    subject(:parent_item_candidates) { test_class.new(item: item).parent_item_candidates }

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

      it 'returns items without parent in the same group' do
        item_of_the_same_group = create(:item, group: item.group)
        _item_of_another_group = create(:item)

        expect(parent_item_candidates).to match([item, item_of_the_same_group])
      end
    end
  end

  describe '#items_page_title' do
    subject(:items_page_title) { test_class.new(group: group).items_page_title }

    context 'when there is a group' do
      let(:group) { build(:group, name: 'Group') }

      it { is_expected.to eq('Item(s) of Group') }
    end

    context 'when there is no group' do
      let(:group) { nil }

      it { is_expected.to eq('Item(s)') }
    end
  end
end
