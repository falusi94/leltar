# frozen_string_literal: true

describe User do
  describe '#read_groups' do
    subject(:read_groups) { user.read_groups }

    let!(:groups) { create_list(:group, 2) }

    context 'when the user is admin' do
      let(:user) { create(:admin) }

      it 'returns all' do
        expect(read_groups).to match(groups)
      end
    end

    context 'when the user has read access to all group' do
      let(:user) { create(:user, :read_all_group) }

      it 'returns all' do
        expect(read_groups).to match(groups)
      end
    end

    context 'when the user has access to one group' do
      let(:user) { create(:user) }

      it 'returns that' do
        create(:read_right, user: user, group: groups.first)

        expect(read_groups).to match([groups.first])
      end
    end
  end

  describe '#write_groups' do
    subject(:write_groups) { user.write_groups }

    let!(:groups) { create_list(:group, 2) }

    context 'when the user is admin' do
      let(:user) { create(:admin) }

      it 'returns all' do
        expect(write_groups).to match(groups)
      end
    end

    context 'when the user has write access to all group' do
      let(:user) { create(:user, :write_all_group) }

      it 'returns all' do
        expect(write_groups).to match(groups)
      end
    end

    context 'when the user has access to one group' do
      let(:user) { create(:user) }

      it 'returns that' do
        create(:write_right, user: user, group: groups.first)

        expect(write_groups).to match([groups.first])
      end
    end
  end
end
