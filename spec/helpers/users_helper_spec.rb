# frozen_string_literal: true

describe UsersHelper do
  let(:test_class) do
    Class.new do
      include UsersHelper
    end
  end

  describe '#groups_without_access' do
    subject(:groups_without_access) { test_class.new.groups_without_access(user) }

    let!(:group) { create(:group) }
    let(:user) { create(:user) }

    context 'when the user has no access to the group' do
      it { is_expected.to match([group]) }
    end

    context 'when the user has already access to the group' do
      before { group.users << user }

      it { is_expected.to match([]) }
    end

    context 'when the user is an admin' do
      let(:user) { create(:user, :admin) }

      it { is_expected.to match([]) }
    end

    context 'when the user has write access' do
      let(:user) { create(:user, :write_all_group) }

      it { is_expected.to match([]) }
    end
  end
end
