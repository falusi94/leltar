# frozen_string_literal: true

describe ItemPolicy do
  subject { described_class.new(Authorization::Scope.new(user: user), item) }

  let(:item) { build_stubbed(:item) }

  describe '#index?' do
    let(:user) { build_stubbed(:user) }

    it { is_expected.to permit_action(:index) }
  end

  context 'when the user has write access to the department' do
    let(:user) { build_stubbed(:user, :write_all_department) }

    it { is_expected.to permit_action(:show)    }
    it { is_expected.to permit_action(:edit)    }
    it { is_expected.to permit_action(:update)  }
    it { is_expected.to permit_action(:destroy) }
    it { is_expected.to permit_action(:create)  }
  end

  context 'when the user has read access to the department' do
    let(:user) { build_stubbed(:user, :read_all_department) }

    it { is_expected.to permit_action(:show)        }
    it { is_expected.not_to permit_action(:edit)    }
    it { is_expected.not_to permit_action(:update)  }
    it { is_expected.not_to permit_action(:destroy) }
    it { is_expected.not_to permit_action(:create)  }
  end

  context 'when the user has no access to the department' do
    let(:user) { build_stubbed(:user) }

    it { is_expected.not_to permit_action(:show)    }
    it { is_expected.not_to permit_action(:edit)    }
    it { is_expected.not_to permit_action(:update)  }
    it { is_expected.not_to permit_action(:destroy) }
    it { is_expected.not_to permit_action(:create)  }
  end

  describe '#new?' do
    let(:item) { Item }

    context 'when the user is admin' do
      let(:user) { create(:admin) }

      it { is_expected.to permit_action(:new) }
    end

    context 'when the user has access to all departments' do
      let(:user) { create(:user, :write_all_department) }

      it { is_expected.to permit_action(:new) }
    end

    context 'when the user has access to at least one department' do
      let(:user) { create(:user) }

      before { create(:write_department_user, user: user) }

      it { is_expected.to permit_action(:new) }
    end

    context 'when the user has no access to any department' do
      let(:user) { create(:user) }

      it { is_expected.not_to permit_action(:new) }
    end
  end

  describe '#search?' do
    let(:item) { Item }

    context 'when the user is admin' do
      let(:user) { build_stubbed(:admin) }

      it { is_expected.to permit_action(:search) }
    end

    context 'when the user has access to all departments' do
      let(:user) { build_stubbed(:user) }

      it { is_expected.to forbid_action(:search) }
    end
  end

  describe 'scope' do
    subject(:scope) { described_class::Scope.new(Authorization::Scope.new(user: user), Item.all).resolve }

    let!(:item) { create(:item) }

    context 'when the user is admin' do
      let(:user) { build_stubbed(:admin) }

      it 'returns every item' do
        expect(scope).to include(item)
      end
    end

    context 'when the user can read all department' do
      let(:user) { build_stubbed(:user, :read_all_department) }

      it 'returns every item' do
        expect(scope).to include(item)
      end
    end

    context 'when the user has access to the department' do
      let(:user) { create(:user, departments: [item.department]) }

      it 'returns every item' do
        expect(scope).to include(item)
      end
    end

    context 'when the user has no access to the department' do
      let(:user) { create(:user) }

      it 'does not return the item' do
        expect(scope).not_to include(item)
      end
    end
  end
end
