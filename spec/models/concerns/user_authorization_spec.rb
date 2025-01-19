# frozen_string_literal: true

RSpec.describe UserAuthorization do
  describe '#authorized_to?' do
    context 'when the user is admin' do
      subject(:user) { build_stubbed(:admin) }

      it { is_expected.to be_authorized_to(:do_whatever, organization: 'organization') }
    end

    context 'when the user is not an admin' do
      subject(:user) { create(:user) }

      let(:organization) { create(:organization) }

      context 'and has access to the organization' do
        before { user.organizations << organization }

        it { is_expected.to be_authorized_to(:show_organization, organization: organization) }
        it { is_expected.not_to be_authorized_to(:create_department, organization: organization) }
      end

      context 'and has no access to the organization' do
        it { is_expected.not_to be_authorized_to(:show_organization, organization: organization) }
      end

      context 'and no organization is provided' do
        it { is_expected.not_to be_strictly_authorized_to(:show_organization, organization: nil) }
      end
    end
  end

  describe '#strictly_authorized_to?' do
    let(:organization) { create(:organization) }

    context 'when the user is admin' do
      subject(:user) { create(:admin) }

      it { is_expected.not_to be_strictly_authorized_to(:show_organization, organization: organization) }
    end

    context 'when the user is not an admin' do
      subject(:user) { create(:user) }

      context 'and has access to the organization' do
        before { user.organizations << organization }

        it { is_expected.to be_strictly_authorized_to(:show_organization, organization: organization) }
        it { is_expected.not_to be_strictly_authorized_to(:create_department, organization: organization) }
      end

      context 'and has no access to the organization' do
        it { is_expected.not_to be_strictly_authorized_to(:show_organization, organization: organization) }
      end

      context 'and no organization is provided' do
        it { is_expected.not_to be_strictly_authorized_to(:show_organization, organization: nil) }
      end
    end
  end
end
