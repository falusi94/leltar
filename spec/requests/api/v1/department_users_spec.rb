# frozen_string_literal: true

describe '/api/department_users' do
  let(:url) { '/api/department_users' }

  describe 'POST #create' do
    let(:params)   { { department_id: create(:department).id, user_id: create(:user).id } }
    let(:resource) { DepartmentUser.last }

    include_examples 'API creates resource'
  end

  describe 'PUT #update' do
    let(:params)           { { write: true } }
    let(:incorrect_params) { { department_id: nil } }
    let(:resource)         { create(:department_user) }

    include_examples 'API updates resource'
  end

  describe 'DELETE #destroy' do
    let(:resource) { create(:department_user) }

    include_examples 'API deletes resource'
  end
end
