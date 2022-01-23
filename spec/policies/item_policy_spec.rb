# frozen_string_literal: true

describe ItemPolicy do
  subject { described_class.new(user, item) }

  let(:item) { build_stubbed(:item) }

  context 'when the user is admin' do
    let(:user) { build_stubbed(:admin) }

    it { is_expected.to permit_action(:edit) }
  end

  context 'when the user is not admin' do
    let(:user) { build_stubbed(:user) }

    it { is_expected.to forbid_action(:edit) }
  end

  describe 'scope' do
    subject(:scope) { described_class::Scope.new(user, Item.all).resolve }

    let!(:item) { create(:item) }

    context 'when the user is admin' do
      let(:user) { build_stubbed(:admin) }

      it 'returns every item' do
        expect(scope).to include(item)
      end
    end

    context 'when the user can read all group' do
      let(:user) { build_stubbed(:user, :read_all_group) }

      it 'returns every item' do
        expect(scope).to include(item)
      end
    end

    context 'when the user has access to the group' do
      let(:user) { create(:user, groups: [item.group]) }

      it 'returns every item' do
        expect(scope).to include(item)
      end
    end

    context 'when the user has no access to the group' do
      let(:user) { create(:user) }

      it 'does not return the item' do
        expect(scope).not_to include(item)
      end
    end
  end
end
