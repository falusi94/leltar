# frozen_string_literal: true

describe 'Departments' do
  describe 'GET #index' do
    subject(:get_departments) { get '/departments' }

    include_examples 'without user redirects to login'

    it 'returns the departments' do
      department = create(:department)
      login_admin

      get_departments

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(department.name)
    end
  end

  describe 'GET #new' do
    subject(:get_new_department) { get '/departments/new' }

    include_examples 'without user redirects to login'

    it 'returns the new department' do
      login_admin

      get_new_department

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #edit' do
    subject(:get_edit_department) { get "/departments/#{department.id}/edit" }

    let(:department) { create(:department) }

    include_examples 'without user redirects to login'

    it 'returns the department edit page' do
      login_admin

      get_edit_department

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(department.name)
    end
  end

  describe 'POST #create' do
    subject(:create_department) { post '/departments', params: { department: attributes_for(:department) } }

    include_examples 'without user redirects to login'

    it 'creates the department' do
      login_admin

      expect { create_department }.to change(Department, :count).by(1)

      expect(response).to have_http_status(:found).and redirect_to("/departments/#{Department.last.id}/items")
    end
  end

  describe 'PUT #update' do
    subject(:update_department) { put "/departments/#{department.id}", params: { department: { name: 'new name' } } }

    let(:department) { create(:department) }

    include_examples 'without user redirects to login'

    it 'updates the department' do
      login_admin

      update_department

      expect(response).to have_http_status(:found)
      expect(department.reload).to have_attributes(name: 'new name')
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_department) { delete "/departments/#{department.id}" }

    let!(:department) { create(:department) }

    include_examples 'without user redirects to login'

    it 'deletes the department' do
      login_admin

      expect { delete_department }.to change(Department, :count).by(-1)

      expect(response).to have_http_status(:found)
    end
  end
end
