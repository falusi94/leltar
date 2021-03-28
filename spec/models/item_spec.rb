# frozen_string_literal: true

describe Item do
  describe '.existing' do
    subject(:existing_items) { described_class.existing }

    context 'whent the status is existing' do
      it 'returns the item' do
        item = create(:item, status: :ok)

        expect(existing_items).to include(item)
      end
    end

    context 'whent the status is not set' do
      it 'returns the item' do
        item = create(:item, status: nil)

        expect(existing_items).to include(item)
      end
    end

    context 'whent the status is not existing' do
      it 'does not return the item' do
        item = create(:item, status: :not_found)

        expect(existing_items).not_to include(item)
      end
    end
  end
end
