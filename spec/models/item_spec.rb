# frozen_string_literal: true

describe Item do
  describe '.existing' do
    subject(:existing_items) { described_class.existing }

    context 'when the status is existing' do
      it 'returns the item' do
        item = create(:item, status: :ok)

        expect(existing_items).to include(item)
      end
    end

    context 'when the status is not set' do
      it 'returns the item' do
        item = create(:item, status: nil)

        expect(existing_items).to include(item)
      end
    end

    context 'when the status is not existing' do
      it 'does not return the item' do
        item = create(:item, status: :not_found)

        expect(existing_items).not_to include(item)
      end
    end
  end

  describe '.not_a_child' do
    subject(:items) { described_class.not_a_child }

    context 'when the item has a parent' do
      it 'does not include it' do
        item = create(:item, :with_parent)

        expect(items).not_to include(item)
      end
    end

    context 'when the item has a child' do
      it 'includes it' do
        item = create(:item, :with_child)

        expect(items).to include(item)
      end
    end
  end

  describe 'validation of purchase_date' do
    context 'when it is in the future' do
      subject { build(:item, purchase_date: 1.day.from_now) }

      include_examples 'the record is invalid'
    end

    context 'when it is not set' do
      subject { build(:item, purchase_date: nil) }

      include_examples 'the record is valid'
    end

    context 'when it is in the today' do
      subject { build(:item, purchase_date: Time.zone.today) }

      include_examples 'the record is valid'
    end

    context 'when it is in the past' do
      subject { build(:item, purchase_date: 1.day.ago) }

      include_examples 'the record is valid'
    end
  end

  describe 'validation of parent has no parent' do
    context 'when parent has parent' do
      subject do
        item_with_parent = create(:item, :with_parent)
        build(:item, parent: item_with_parent, department: item_with_parent.department)
      end

      include_examples 'the record is invalid'
    end

    context 'when parent has no parent' do
      subject do
        item_without_parent = create(:item)
        build(:item, parent: item_without_parent, department: item_without_parent.department)
      end

      include_examples 'the record is valid'
    end
  end

  describe 'validation of children have no child' do
    context 'when a child has child' do
      subject do
        item_with_child = create(:item, :with_child)
        build(:item, children: [item_with_child], department: item_with_child.department)
      end

      include_examples 'the record is invalid'
    end

    context 'when none of the children has child' do
      subject do
        item_without_child = create(:item)
        build(:item, children: [item_without_child], department: item_without_child.department)
      end

      include_examples 'the record is valid'
    end
  end

  describe 'validation of department of parent' do
    let(:parent) { create(:item) }

    context 'when parent belongs to a different department' do
      subject { build(:item, parent: parent) }

      include_examples 'the record is invalid'
    end

    context 'when parent belongs to the same department' do
      subject { build(:item, parent: parent, department: parent.department) }

      include_examples 'the record is valid'
    end
  end

  describe 'validation of department of children' do
    let(:child) { create(:item) }

    context 'when a child belongs to a different department' do
      subject { build(:item, children: [child]) }

      include_examples 'the record is invalid'
    end

    context 'when child belongs to the same department' do
      subject { build(:item, children: [child], department: child.department) }

      include_examples 'the record is valid'
    end
  end

  describe '#init_depreciation callback' do
    context 'when automatic depreciation is enabled' do
      it 'initializes depreciation' do
        depreciation_config = create(:depreciation_config, :with_automatic_depreciation)
        item = create(:item, organization: depreciation_config.organization)

        expect(item.depreciation_details).to be_present.and have_attributes(
          useful_life:   depreciation_config.automatic_depreciation_useful_life,
          salvage_value: depreciation_config.automatic_depreciation_salvage_value
        )
      end
    end

    context 'when automatic depreciation is disabled' do
      it 'does not initialize depreciation' do
        expect { create(:item) }.not_to change(DepreciationDetails, :count)
      end
    end
  end

  describe '#parent?' do
    context 'when it has any child' do
      it 'returns true' do
        item = create(:item, :with_child).reload

        expect(item).to be_parent
      end
    end

    context 'when it has no child' do
      it 'returns false' do
        item = create(:item)

        expect(item).not_to be_parent
      end
    end
  end

  describe '#child?' do
    context 'when it has parent' do
      it 'returns true' do
        item = create(:item, :with_parent)

        expect(item).to be_child
      end
    end

    context 'when it has no parent' do
      it 'returns false' do
        item = create(:item)

        expect(item).not_to be_child
      end
    end
  end
end
