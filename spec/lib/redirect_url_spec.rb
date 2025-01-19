# frozen_string_literal: true

RSpec.describe RedirectUrl do
  subject(:redirect_url) { described_class.generate(user) }

  context 'when there is no organization' do
    context 'and the user is admin' do
      let(:user) { build_stubbed(:user) }

      it { is_expected.to eq('/setup/users/new') }
    end
  end

  context 'when there is an organization' do
    let!(:organization) { create(:organization) }

    context 'and the user is admin' do
      let(:user) { build_stubbed(:admin) }

      it { is_expected.to eq("/org/#{organization.slug}/items") }
    end

    context 'and the user has access to the organization' do
      let(:user) { create(:user) }

      before { organization.users << user }

      context 'and the user has many departments' do
        before do
          create_list(:department, 2, organization: organization).each { |department| department.users << user }
        end

        it { is_expected.to eq("/org/#{organization.slug}/items") }
      end

      context 'and the user has one department' do
        let(:department) { create(:department, organization: organization) }

        before { department.users << user }

        it { is_expected.to eq("/org/#{organization.slug}/departments/#{department.id}/items") }
      end
    end

    context 'and the user has no access to the organization' do
      let(:user) { create(:user) }
      let(:department) { create(:department, organization: organization) }

      before { department.users << user }

      it { is_expected.to be(nil) }
    end

    context 'and the user has no access to any departments' do
      let(:user) { create(:user) }

      before do
        organization.users << user
        create(:department, organization: organization)
      end

      it { is_expected.to be(nil) }
    end
  end

  context 'when there is a last organization' do
    before { create(:organization) }

    context 'and the user is admin' do
      let(:user) { build_stubbed(:admin) }

      context 'and has last organization' do
        let(:user) { build_stubbed(:admin, :with_last_organization) }

        it { is_expected.to eq("/org/#{user.last_organization.slug}/items") }
      end
    end
  end
end
