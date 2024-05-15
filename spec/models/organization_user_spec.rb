# frozen_string_literal: true

RSpec.describe OrganizationUser do
  describe '.with_access' do
    subject(:organization_users) { described_class.with_access(access) }

    let!(:organization_user) { create(:organization_user, :observer) }

    context 'when the role has the specified access' do
      let(:access) { :show_department }

      it { is_expected.to include(organization_user) }
    end

    context 'when the role does not have the specified access' do
      let(:access) { :update_department }

      it { is_expected.to be_empty }
    end
  end

  ORGANIZATION_ROLE_ACCESSES.each do |method_name|
    describe "##{method_name}" do
      let(:organization_user) { build_stubbed(:organization_user, :observer) }
      let(:role) { OrganizationRole.find_by_name('observer') } # rubocop:disable Rails/DynamicFindBy

      before do
        allow(role).to receive(method_name).and_call_original
        allow(OrganizationRole).to receive(:find_by_name).and_return(role)
      end

      it 'delegates the method to the role' do
        organization_user.public_send(method_name)

        expect(role).to have_received(method_name)
      end
    end
  end
end
