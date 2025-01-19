# frozen_string_literal: true

describe ItemPolicy do
  subject { described_class.new(auth_scope, item) }

  let(:auth_scope) { Authorization::Scope.new(user: user) }
  let(:item)       { build_stubbed(:item) }
  let(:user)       { build_stubbed(:user) }

  describe '#index?' do
    it { is_expected.to permit_action(:index) }
  end

  %i[show create update destroy].each do |action|
    describe "##{action}?" do
      let(:department_policy) { DepartmentPolicy.new(auth_scope, item.department) }

      before do
        allow(Pundit).to receive(:policy).with(auth_scope, item.department).and_return(department_policy)
        allow(department_policy).to receive(:"#{action}_item?").and_return(result)
      end

      context "when the user access to #{action}_item on the department" do
        let(:result) { true }

        it { is_expected.to permit_action(action) }
      end

      context "when the user no access to #{action}_item on the department" do
        let(:result) { false }

        it { is_expected.to forbid_action(action) }
      end
    end
  end

  describe '#new?' do
    let(:organization_policy) { OrganizationPolicy.new(auth_scope, item.organization) }

    before do
      allow(Pundit).to receive(:policy).with(auth_scope, item.organization).and_return(organization_policy)
      allow(organization_policy).to receive(:create_item?).and_return(result)
    end

    context 'when the user access to create_item on the department' do
      let(:result) { true }

      it { is_expected.to permit_action(:new) }
    end

    context 'when the user no access to create_item on the department' do
      let(:auth_scope) { Authorization::Scope.new(user: user, organization: item.organization) }
      let(:item)       { create(:item) }
      let(:user)       { create(:user) }
      let(:result)     { false }

      it { is_expected.to forbid_action(:new) }

      context 'and the user has write access to any departments of the organization' do
        before { create(:department_user, :write, user: user, department: item.department) }

        it { is_expected.to permit_action(:new) }
      end

      context 'and the user has read access to any departments of the organization' do
        before { create(:department_user, user: user, department: item.department) }

        it { is_expected.to forbid_action(:new) }
      end
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
