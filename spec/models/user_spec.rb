# frozen_string_literal: true

describe User do
  describe '#departments.with_read_access' do
    subject(:departmets_with_read_access) { user.departments.with_read_access }

    let!(:departments) { create_list(:department, 2) }

    context 'when the user is admin' do
      let(:user) { create(:admin) }

      it 'returns all' do
        expect(departmets_with_read_access).to match(departments)
      end
    end

    context 'when the user has read access to all department' do
      subject(:departmets_with_read_access) do
        user.departments.with_read_access(organization: organization_user.organization)
      end

      let(:organization_user) { create(:organization_user, :admin) }
      let(:user)              { organization_user.user }

      it 'returns all' do
        expect(departmets_with_read_access).to match(departments)
      end
    end

    context 'when the user has access to one department' do
      let(:user) { create(:user) }

      it 'returns that' do
        create(:read_department_user, user: user, department: departments.first)

        expect(departmets_with_read_access).to match([departments.first])
      end
    end
  end

  describe '#departments.with_write_access' do
    subject(:departmets_with_write_access) { user.departments.with_write_access }

    let!(:departments) { create_list(:department, 2) }

    context 'when the user is admin' do
      let(:user) { create(:admin) }

      it 'returns all' do
        expect(departmets_with_write_access).to match(departments)
      end
    end

    context 'when the user has write access to all department' do
      subject(:departmets_with_write_access) do
        user.departments.with_write_access(organization: organization_user.organization)
      end

      let(:organization_user) { create(:organization_user, :admin) }
      let(:user)              { organization_user.user }

      it 'returns all' do
        expect(departmets_with_write_access).to match(departments)
      end
    end

    context 'when the user has access to one department' do
      let(:user) { create(:user) }

      it 'returns that' do
        create(:write_department_user, user: user, department: departments.first)

        expect(departmets_with_write_access).to match([departments.first])
      end
    end
  end
end
