# frozen_string_literal: true

describe LocationPolicy do
  subject { described_class.new(Authorization::Scope.new(user: user), location) }

  let(:location) { build_stubbed(:location) }

  context 'when the user is admin' do
    let(:user) { build_stubbed(:admin) }

    it { is_expected.to permit_action(:edit)    }
    it { is_expected.to permit_action(:update)  }
    it { is_expected.to permit_action(:destroy) }
  end

  context 'when the user is not admin' do
    context 'and has no access on the organization' do
      let(:user) { build_stubbed(:user) }

      it { is_expected.to forbid_action(:edit)    }
      it { is_expected.to forbid_action(:update)  }
      it { is_expected.to forbid_action(:destroy) }
    end

    context 'and has access on the organization' do
      let(:user) { organization_user.user }
      let(:organization_user) { create(:organization_user, :admin) }

      before { location.organization = organization_user.organization }

      it { is_expected.to permit_action(:edit)    }
      it { is_expected.to permit_action(:update)  }
      it { is_expected.to permit_action(:destroy) }
    end
  end

  %i[index create].each do |action|
    describe "##{action}?" do
      subject(:policy) { described_class.new(auth_scope, location) }

      let(:auth_scope)   { Authorization::Scope.new(user: build_stubbed(:user), organization: organization) }
      let(:organization) { build_stubbed(:organization) }
      let(:organization_policy) do
        instance_double(OrganizationPolicy, "#{action}_location?": true)
      end

      before do
        allow(OrganizationPolicy).to receive(:new).with(auth_scope, organization).and_return(organization_policy)
      end

      it 'proxies the call to OrganizationPolicy' do
        policy.public_send(:"#{action}?")

        expect(organization_policy).to have_received(:"#{action}_location?")
      end
    end
  end
end
