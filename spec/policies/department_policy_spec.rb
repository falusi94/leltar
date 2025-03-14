# frozen_string_literal: true

describe DepartmentPolicy do
  subject { described_class.new(Authorization::Scope.new(user: user), department) }

  let(:department) { build_stubbed(:department) }

  context 'when the user is admin' do
    let(:user) { build_stubbed(:admin) }

    it { is_expected.to permit_action(:index)   }
    it { is_expected.to permit_action(:show)    }
    it { is_expected.to permit_action(:edit)    }
    it { is_expected.to permit_action(:update)  }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'when the user is not admin' do
    context 'and has no access on the organization' do
      let(:user) { build_stubbed(:user) }

      it { is_expected.to permit_action(:index)   }
      it { is_expected.to forbid_action(:show)    }
      it { is_expected.to forbid_action(:edit)    }
      it { is_expected.to forbid_action(:update)  }
      it { is_expected.to forbid_action(:destroy) }
    end

    context 'and has access on the organization' do
      let(:user) { organization_user.user }
      let(:organization_user) { create(:organization_user, :admin) }

      before { department.organization = organization_user.organization }

      it { is_expected.to permit_action(:index)   }
      it { is_expected.to permit_action(:show)    }
      it { is_expected.to permit_action(:edit)    }
      it { is_expected.to permit_action(:update)  }
      it { is_expected.to permit_action(:destroy) }
    end
  end

  describe '#show_item?' do
    let(:department) { create(:department) }
    let(:user) { create(:user) }

    context 'when the user is admin' do
      let(:user) { create(:admin) }

      it { is_expected.to permit_action(:show_item) }
    end

    context 'when the user has access on the organization' do
      let(:user) { organization_user.user }
      let(:organization_user) { create(:organization_user, :admin) }

      before { department.organization = organization_user.organization }

      it { is_expected.to permit_action(:show_item) }
    end

    context 'when the user has write access to the department' do
      before { create(:write_department_user, department: department, user: user) }

      it { is_expected.to permit_action(:show_item) }
    end

    context 'when the user has read access to the department' do
      before { create(:read_department_user, department: department, user: user) }

      it { is_expected.to permit_action(:show_item) }
    end

    context 'when the user has no access to the department' do
      it { is_expected.to forbid_action(:show_item) }
    end
  end

  %i[update_item create_item destroy_item].each do |action_name|
    describe "##{action_name}?" do
      let(:department) { create(:department) }
      let(:user) { create(:user) }

      context 'when the user is admin' do
        let(:user) { create(:admin) }

        it { is_expected.to permit_action(action_name) }
      end

      context 'when the user has access on the organization' do
        let(:user) { organization_user.user }
        let(:organization_user) { create(:organization_user, :admin) }

        before { department.organization = organization_user.organization }

        it { is_expected.to permit_action(action_name) }
      end

      context 'when the user has write access to the department' do
        before { create(:write_department_user, department: department, user: user) }

        it { is_expected.to permit_action(action_name) }
      end

      context 'when the user has read access to the department' do
        before { create(:read_department_user, department: department, user: user) }

        it { is_expected.to forbid_action(action_name) }
      end

      context 'when the user has no access to the department' do
        it { is_expected.to forbid_action(action_name) }
      end
    end
  end

  describe 'scope' do
    subject(:scope) do
      described_class::Scope.new(
        Authorization::Scope.new(user: user, organization: organization),
        Department.all
      ).resolve
    end

    let(:organization) { department.organization }
    let(:department)   { create(:department) }

    context 'when the user is admin' do
      let(:user) { build_stubbed(:admin) }

      context 'and the department belongs to the organization' do
        it { is_expected.to contain_exactly(department) }
      end

      context 'and the department not belong to the organization' do
        let(:organization) { build_stubbed(:organization) }

        it { is_expected.to be_empty }
      end
    end

    context 'when the user has access to the organization' do
      let(:user) { create(:organization_user, :admin, organization: organization).user }

      context 'and the department belongs to the organization' do
        it { is_expected.to contain_exactly(department) }
      end

      context 'and the department not belong to the organization' do
        let(:organization) { create(:organization) }

        it { is_expected.to be_empty }
      end
    end

    context 'when the user has access to the department' do
      let(:user) { create(:department_user, department: department).user }

      context 'and the department belongs to the organization' do
        it { is_expected.to contain_exactly(department) }
      end

      context 'and the department not belong to the organization' do
        let(:organization) { create(:organization) }

        it { is_expected.to be_empty }
      end
    end

    context 'when the user has no access to the department' do
      let(:user) { create(:user) }

      it { is_expected.to be_empty }
    end
  end
end
