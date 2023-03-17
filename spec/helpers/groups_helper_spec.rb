# frozen_string_literal: true

describe GroupsHelper do
  let(:test_class) do
    Class.new do
      include GroupsHelper
    end
  end

  describe '#users_with_no_access_to_group' do
    subject(:users_with_no_access_to_group) { test_class.new.users_with_no_access_to_group(group) }

    let!(:user) { create(:user) }
    let(:group) { create(:group) }

    context 'when the user has no access to the group' do
      it { is_expected.to match([user]) }
    end

    context 'when the user has already access to the group' do
      before { group.users << user }

      it { is_expected.to match([]) }
    end

    context 'when the user is an admin' do
      let(:user) { create(:user, :admin) }

      it { is_expected.to match([]) }
    end

    context 'when the user has read access' do
      let(:user) { create(:user, :read_all_group) }

      it { is_expected.to match([]) }
    end
  end
end
