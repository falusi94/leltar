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
end
