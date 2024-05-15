# frozen_string_literal: true

RSpec.describe OrganizationRole do
  let(:organization_roles_config) { Rails.configuration.x.roles.organization_roles }

  describe '.all' do
    subject(:organization_roles) { described_class.all }

    it { is_expected.to all(be_a(described_class)) }

    it 'returns all roles' do
      expect(organization_roles.count).to eq(organization_roles_config.count)
    end
  end

  describe '.roles_with_access' do
    subject(:roles_with_access) { described_class.roles_with_access(access) }

    context 'when not all roles have the provided access' do
      let(:access) { :show_department }

      it { is_expected.to match_array(%w[admin observer]) }
    end

    context 'when an invalid access is provided' do
      let(:access) { :invalid }

      it 'raises NoMethodError' do
        expect { roles_with_access }.to raise_error(NoMethodError)
      end
    end
  end

  describe '.find_by_name' do
    subject(:role) { described_class.find_by_name(name) } # rubocop:disable Rails/DynamicFindBy

    context 'when an existing name is provided' do
      let(:name) { 'admin' }

      it { is_expected.to be_a(described_class).and have_attributes(name: name) }
    end

    context 'when a non-existing name is provided' do
      let(:name) { 'non-existing' }

      it { is_expected.to be(nil) }
    end
  end
end
