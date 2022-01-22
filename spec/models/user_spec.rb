# frozen_string_literal: true

describe User do
  describe '#can_read?' do
    subject(:can_read) { user.can_read?(group.id) }

    let(:group) { create(:group) }

    context 'when the user is admin' do
      let(:user) { create(:admin) }

      it 'returns true' do
        expect(can_read).to be(true)
      end
    end

    context 'when the user has access to all groups' do
      let(:user) { create(:user, :read_all_group) }

      it 'returns true' do
        expect(can_read).to be(true)
      end
    end

    context 'when the user has access to the group' do
      let(:user) { create(:user) }

      it 'returns true' do
        create(:read_right, group: group, user: user)

        expect(can_read).to be(true)
      end
    end

    context 'when the user has no access to the group' do
      let(:user) { create(:user) }

      it 'returns false' do
        expect(can_read).to be(false)
      end
    end
  end

  describe '#can_write?' do
    subject(:can_write) { user.can_write?(group.id) }

    let(:group) { create(:group) }

    context 'when the user is admin' do
      let(:user) { create(:admin) }

      it 'returns true' do
        expect(can_write).to be(true)
      end
    end

    context 'when the user has access to all groups' do
      let(:user) { create(:user, :write_all_group) }

      it 'returns true' do
        expect(can_write).to be(true)
      end
    end

    context 'when the user has access to the group' do
      let(:user) { create(:user) }

      it 'returns true' do
        create(:write_right, group: group, user: user)

        expect(can_write).to be(true)
      end
    end

    context 'when the user has no access to the group' do
      let(:user) { create(:user) }

      it 'returns false' do
        expect(can_write).to be(false)
      end
    end
  end
end
