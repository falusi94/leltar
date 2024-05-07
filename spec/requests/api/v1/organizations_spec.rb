# frozen_string_literal: true

describe '/api/organizations' do
  let(:url) { '/api/organizations' }

  describe 'GET #index' do
    let(:resources) { Organization.all }

    include_examples 'API lists resources'
  end

  describe 'POST #create' do
    let(:params)   { attributes_for(:organization) }
    let(:resource) { Organization.last }

    include_examples 'API creates resource'
  end

  describe 'PUT #update' do
    let(:params)           { { name: 'New name' } }
    let(:incorrect_params) { { name: '' } }
    let(:resource)         { create(:organization) }

    include_examples 'API updates resource'
  end

  describe 'DELETE #destroy' do
    let(:resource) { create(:organization) }

    include_examples 'API deletes resource'
  end
end
