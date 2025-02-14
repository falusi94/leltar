# frozen_string_literal: true

describe DepartmentUserPolicy do
  subject do
    described_class.new(Authorization::Scope.new(user: user, organization: try(:organization)), department_user)
  end

  let(:department_user) { build_stubbed(:department_user) }

  context 'when the user is admin' do
    let(:user) { build_stubbed(:admin) }

    it { is_expected.to permit_action(:create)  }
    it { is_expected.to permit_action(:update)  }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'when the user is not admin' do
    let(:user) { build_stubbed(:user) }

    it { is_expected.to forbid_action(:create)  }
    it { is_expected.to forbid_action(:update)  }
    it { is_expected.to forbid_action(:destroy) }
  end

  context 'when the user has access to the organization' do
    let(:user)            { create(:user) }
    let(:department_user) { create(:department_user) }
    let(:organization)    { department_user.department.organization }

    before { create(:organization_user, :admin, user: user, organization: organization) }

    it { is_expected.to permit_action(:create)  }
    it { is_expected.to permit_action(:update)  }
    it { is_expected.to permit_action(:destroy) }
  end

  describe 'scope' do
    subject(:scope) do
      described_class::Scope.new(
        Authorization::Scope.new(user: user, organization: organization),
        DepartmentUser.all
      ).resolve
    end

    let(:organization)    { department_user.organization }
    let(:department_user) { create(:department_user) }

    context 'when the user is admin' do
      let(:user) { build_stubbed(:admin) }

      context 'and the department user belongs to the organization' do
        it { is_expected.to contain_exactly(department_user) }
      end

      context 'and the department does not belong to the organization' do
        let(:organization) { build_stubbed(:organization) }

        it { is_expected.to be_empty }
      end
    end

    context 'when the user has access to the organization' do
      let(:user) { create(:organization_user, :admin, organization: organization).user }

      context 'and the department user belongs to the organization' do
        it { is_expected.to contain_exactly(department_user) }
      end

      context 'and the department does not belong to the organization' do
        let(:organization) { create(:organization) }

        it { is_expected.to be_empty }
      end
    end

    context 'when the user has no access to the department' do
      let(:user) { create(:user) }

      context 'and the department user belongs to the organization and the user' do
        let(:user) { department_user.user }

        it { is_expected.to contain_exactly(department_user) }
      end

      context 'and the department does not belong to the user' do
        it { is_expected.to be_empty }
      end

      context 'and the department does not belong to the organization' do
        let(:organization) { create(:organization) }

        it { is_expected.to be_empty }
      end
    end
  end
end
