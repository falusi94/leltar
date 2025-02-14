# frozen_string_literal: true

describe '/api/organization/:organization_id/locations' do
  let(:organization) { create(:organization) }
  let(:url)          { "/api/organizations/#{organization.id}/locations" }

  describe 'GET #index' do
    let(:resources) { create_list(:location, 1, organization: organization) }

    include_examples 'API lists resources'
  end

  describe 'GET #show' do
    let(:resource) { create(:location, organization: organization) }

    include_examples 'API shows resource'
  end

  describe 'POST #create' do
    let(:params)           { attributes_for(:location) }
    let(:incorrect_params) { {} }
    let(:resource)         { Location.first }

    include_examples 'API creates resource'
  end

  describe 'PUT #update' do
    let(:params)           { { name: 'New name' } }
    let(:incorrect_params) { { name: '' } }
    let(:resource)         { create(:location, organization: organization) }

    include_examples 'API updates resource'
  end

  describe 'DELETE #destroy' do
    let(:resource) { create(:location, organization: organization) }

    include_examples 'API deletes resource'
  end
end
