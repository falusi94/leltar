# frozen_string_literal: true

describe Status do
  let(:status) { described_class.new(organization) }
  let(:organization) { create(:organization) }

  before { create(:new_session_start_attribute) }

  describe '#all_item_count' do
    it 'returns the count of items' do
      create_list(:item, 2, organization: organization)

      expect(status.all_item_count).to eq(2)
    end
  end

  describe '#existing_item_count' do
    it 'returns the count of existing items with last check' do
      create_list(:item, 2, organization: organization)

      expect(status.all_item_count).to eq(2)
    end
  end

  describe '#finished_item_count' do
    it 'returns count of existing items where last check is after new session' do
      create(:item, last_check: Time.zone.tomorrow, organization: organization)

      expect(status.finished_item_count).to eq(1)
    end
  end

  describe '#at_member_item_count' do
    it 'returns count of existing items at department member' do
      create(:item, status: :at_member, organization: organization)

      expect(status.at_member_item_count).to eq(1)
    end
  end
end
