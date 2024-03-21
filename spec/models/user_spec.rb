# frozen_string_literal: true

describe User do
  describe '#read_departments' do
    subject(:read_departments) { user.read_departments }

    let!(:departments) { create_list(:department, 2) }

    context 'when the user is admin' do
      let(:user) { create(:admin) }

      it 'returns all' do
        expect(read_departments).to match(departments)
      end
    end

    context 'when the user has read access to all department' do
      let(:user) { create(:user, :read_all_department) }

      it 'returns all' do
        expect(read_departments).to match(departments)
      end
    end

    context 'when the user has access to one department' do
      let(:user) { create(:user) }

      it 'returns that' do
        create(:read_department_user, user: user, department: departments.first)

        expect(read_departments).to match([departments.first])
      end
    end
  end

  describe '#write_departments' do
    subject(:write_departments) { user.write_departments }

    let!(:departments) { create_list(:department, 2) }

    context 'when the user is admin' do
      let(:user) { create(:admin) }

      it 'returns all' do
        expect(write_departments).to match(departments)
      end
    end

    context 'when the user has write access to all department' do
      let(:user) { create(:user, :write_all_department) }

      it 'returns all' do
        expect(write_departments).to match(departments)
      end
    end

    context 'when the user has access to one department' do
      let(:user) { create(:user) }

      it 'returns that' do
        create(:write_department_user, user: user, department: departments.first)

        expect(write_departments).to match([departments.first])
      end
    end
  end
end
