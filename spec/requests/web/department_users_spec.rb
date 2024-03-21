# frozen_string_literal: true

describe 'DepartmentUsers' do
  describe 'POST #create' do
    subject(:create_department_user) do
      post '/department_users', params: { department_user: { user_id: user.id, department_id: department.id } }
    end

    let(:department) { create(:department) }
    let(:user) { create(:user) }

    include_examples 'without user redirects to login'

    context 'when the user is admin' do
      it 'adds the department_user' do
        login_admin

        expect { create_department_user }.to change(DepartmentUser, :count).by(1)

        expect(DepartmentUser.last).to have_attributes(user: user, department: department)
      end
    end
  end

  describe 'PUT #update' do
    subject(:update_department_user) { put "/department_users/#{department_user.id}" }

    let(:department_user) { create(:read_department_user) }

    include_examples 'without user redirects to login'

    context 'when the user is admin' do
      it 'toggles the write flag' do
        login_admin

        update_department_user

        expect(department_user.reload).to have_attributes(write: true)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_department_user) { delete "/department_users/#{department_user.id}" }

    let!(:department_user) { create(:read_department_user) }

    include_examples 'without user redirects to login'

    context 'when the user is admin' do
      it 'toggles the write flag' do
        login_admin

        expect { delete_department_user }.to change(DepartmentUser, :count).by(-1)
      end
    end
  end
end
