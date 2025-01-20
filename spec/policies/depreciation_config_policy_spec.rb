# frozen_string_literal: true

describe DepreciationConfigPolicy do
  subject(:policy) { described_class.new(auth_scope, depreciation_config) }

  let(:auth_scope)          { Authorization::Scope.new(user: build_stubbed(:user), organization: organization) }
  let(:organization)        { build_stubbed(:organization) }
  let(:depreciation_config) { build_stubbed(:depreciation_config, organization: organization) }
  let(:organization_policy) do
    instance_double(OrganizationPolicy, show_depreciation_config?: true, update_depreciation_config?: true)
  end

  before { allow(OrganizationPolicy).to receive(:new).with(auth_scope, organization).and_return(organization_policy) }

  describe '#show?' do
    it 'proxies the call to OrganizationPolicy' do
      policy.show?

      expect(organization_policy).to have_received(:show_depreciation_config?)
    end
  end

  describe '#update?' do
    it 'proxies the call to OrganizationPolicy' do
      policy.update?

      expect(organization_policy).to have_received(:update_depreciation_config?)
    end
  end
end
