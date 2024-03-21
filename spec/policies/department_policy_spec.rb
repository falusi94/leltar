# frozen_string_literal: true

describe DepartmentPolicy do
  subject { described_class.new(user, department) }

  let(:department) { build_stubbed(:department) }

  context 'when the user is admin' do
    let(:user) { build_stubbed(:admin) }

    it { is_expected.to permit_action(:index)   }
    it { is_expected.to permit_action(:show)    }
    it { is_expected.to permit_action(:edit)    }
    it { is_expected.to permit_action(:create)  }
    it { is_expected.to permit_action(:update)  }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'when the user is not admin' do
    let(:user) { build_stubbed(:user) }

    it { is_expected.to permit_action(:index)   }
    it { is_expected.to forbid_action(:show)    }
    it { is_expected.to forbid_action(:edit)    }
    it { is_expected.to forbid_action(:create)  }
    it { is_expected.to forbid_action(:update)  }
    it { is_expected.to forbid_action(:destroy) }
  end

  describe '#read_items?' do
    let(:department) { create(:department) }

    context 'when the user is admin' do
      let(:user) { create(:admin) }

      it { is_expected.to permit_action(:read_items) }
    end

    context 'when the user has access to all departments' do
      let(:user) { create(:user, :read_all_department) }

      it { is_expected.to permit_action(:read_items) }
    end

    context 'when the user has access to the department' do
      let(:user) { create(:user) }

      before { create(:read_department_user, department: department, user: user) }

      it { is_expected.to permit_action(:read_items) }
    end

    context 'when the user has no access to the department' do
      let(:user) { create(:user) }

      it { is_expected.not_to permit_action(:read_items) }
    end
  end

  describe '#write_items?' do
    let(:department) { create(:department) }

    context 'when the user is admin' do
      let(:user) { create(:admin) }

      it { is_expected.to permit_action(:write_items) }
    end

    context 'when the user has access to all departments' do
      let(:user) { create(:user, :write_all_department) }

      it { is_expected.to permit_action(:write_items) }
    end

    context 'when the user has access to the department' do
      let(:user) { create(:user) }

      before { create(:write_department_user, department: department, user: user) }

      it { is_expected.to permit_action(:write_items) }
    end

    context 'when the user has no access to the department' do
      let(:user) { create(:user) }

      it { is_expected.not_to permit_action(:write_items) }
    end
  end
end
