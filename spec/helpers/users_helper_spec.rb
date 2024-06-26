# frozen_string_literal: true

describe UsersHelper do
  let(:test_class) do
    Class.new do
      include UsersHelper
    end
  end

  describe '#departments_without_access' do
    subject(:departments_without_access) { test_class.new.departments_without_access(user) }

    let!(:department) { create(:department) }
    let(:user) { create(:user) }

    context 'when the user has no access to the department' do
      it { is_expected.to match([department]) }
    end

    context 'when the user has already access to the department' do
      before { department.users << user }

      it { is_expected.to match([]) }
    end

    context 'when the user is an admin' do
      let(:user) { create(:user, :admin) }

      it { is_expected.to match([]) }
    end

    context 'when the user has write access' do
      let(:user) { create(:user, :write_all_department) }

      it { is_expected.to match([]) }
    end
  end
end
