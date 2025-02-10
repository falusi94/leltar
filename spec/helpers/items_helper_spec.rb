# frozen_string_literal: true

describe ItemsHelper do
  let(:test_class) do
    Class.new do
      include ItemsHelper
      include Pundit::Authorization
      include Authorization::ControllerMixin

      attr_reader :current_user, :current_organization

      def initialize(current_user: nil, current_organization: nil)
        @current_user         = current_user
        @current_organization = current_organization
      end
    end
  end

  describe '#parent_item_candidates' do
    subject(:parent_item_candidates) do
      test_class.new(current_user: user, current_organization: organization).parent_item_candidates(item)
    end

    let(:user) { create(:user) }
    let(:organization) { create(:organization) }

    before { create(:organization_user, :admin, organization: organization, user: user) }

    context 'when no item is passed' do
      let(:item) { nil }

      it 'returns all items' do
        item = create(:item, organization: organization)

        expect(parent_item_candidates).to contain_exactly(item)
      end

      context 'when the items are in hierarchy' do
        it 'returns only the parent' do
          item = create(:item, :with_child, organization: organization)

          expect(parent_item_candidates).to contain_exactly(item)
        end
      end

      context 'when the item belongs to another organization' do
        it 'does not return it' do
          create(:item)

          expect(parent_item_candidates).to be_empty
        end
      end
    end

    context 'when there is an item' do
      let(:item) { build_stubbed(:item, department_id: department.id) }
      let(:department) { create(:department, organization: organization) }

      context 'when the item belongs to the same department' do
        it 'returns all items' do
          item = create(:item, department: department)

          expect(parent_item_candidates).to contain_exactly(item)
        end
      end

      context 'when the item belongs to another department' do
        it 'does not return it' do
          create(:item, organization: organization)

          expect(parent_item_candidates).to be_empty
        end
      end

      context 'when the items are in hierarchy' do
        it 'returns only the parent' do
          item = create(:item, :with_child, department: department)

          expect(parent_item_candidates).to contain_exactly(item)
        end
      end

      context 'when the item belongs to another organization' do
        it 'does not return it' do
          create(:item)

          expect(parent_item_candidates).to be_empty
        end
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
