# frozen_string_literal: true

describe '/api/organization/:organization_id/departments' do
  let(:organization) { create(:organization) }
  let(:url)          { "/api/organizations/#{organization.id}/departments" }

  describe 'GET #index' do
    let(:resources) { create_list(:department, 1, organization: organization) }

    include_examples 'API lists resources'
  end

  describe 'GET #show' do
    let(:resource) { create(:department, organization: organization) }

    include_examples 'API shows resource'
  end

  describe 'POST #create' do
    let(:params)           { attributes_for(:department) }
    let(:incorrect_params) { {} }
    let(:resource)         { Department.first }

    include_examples 'API creates resource'
  end

  describe 'PUT #update' do
    let(:params)           { { name: 'New name' } }
    let(:incorrect_params) { { name: '' } }
    let(:resource)         { create(:department, organization: organization) }

    include_examples 'API updates resource'
  end

  describe 'DELETE #destroy' do
    let(:resource) { create(:department, organization: organization) }

    include_examples 'API deletes resource'
  end
end
