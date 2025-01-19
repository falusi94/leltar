# frozen_string_literal: true

describe DepartmentsHelper do
  let(:test_class) do
    Class.new do
      include DepartmentsHelper
    end
  end

  describe '#users_with_no_access_to_department' do
    subject(:users_with_no_access_to_department) do
      test_class.new.users_with_no_access_to_department(department, organization)
    end

    let(:department)   { create(:department) }
    let(:organization) { create(:organization) }
    let!(:user)        { create(:user) }

    context 'when the user has no access to the department' do
      it { is_expected.to contain_exactly(user) }
    end

    context 'when the user has already access to the department' do
      before { department.users << user }

      it { is_expected.to be_empty }
    end

    context 'when the user is an admin' do
      let(:user) { create(:user, :admin) }

      it { is_expected.to be_empty }
    end

    context 'when the user has access to the organization' do
      before { create(:organization_user, :admin, user: user, organization: organization) }

      it { is_expected.to be_empty }
    end
  end
end
