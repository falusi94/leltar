# frozen_string_literal: true

describe '/api/organization/:organization_id/department_users' do
  let(:organization) { create(:organization) }
  let(:url)          { "/api/organizations/#{organization.id}/department_users" }

  describe 'POST #create' do
    let(:params)   { { department_id: create(:department, organization: organization).id, user_id: create(:user).id } }
    let(:resource) { DepartmentUser.last }

    include_examples 'API creates resource'
  end

  describe 'PUT #update' do
    let(:params)           { { write: true } }
    let(:incorrect_params) { { department_id: nil } }
    let(:resource)         { create(:department_user, department: create(:department, organization: organization)) }

    include_examples 'API updates resource'
  end

  describe 'DELETE #destroy' do
    let(:resource) { create(:department_user, department: create(:department, organization: organization)) }

    include_examples 'API deletes resource'
  end
end
