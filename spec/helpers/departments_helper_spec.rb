# frozen_string_literal: true

describe DepartmentsHelper do
  let(:test_class) do
    Class.new do
      include DepartmentsHelper
    end
  end

  describe '#users_with_no_access_to_department' do
    subject(:users_with_no_access_to_department) { test_class.new.users_with_no_access_to_department(department) }

    let!(:user) { create(:user) }
    let(:department) { create(:department) }

    context 'when the user has no access to the department' do
      it { is_expected.to match([user]) }
    end

    context 'when the user has already access to the department' do
      before { department.users << user }

      it { is_expected.to match([]) }
    end

    context 'when the user is an admin' do
      let(:user) { create(:user, :admin) }

      it { is_expected.to match([]) }
    end

    context 'when the user has read access' do
      let(:user) { create(:user, :read_all_department) }

      it { is_expected.to match([]) }
    end
  end
end
