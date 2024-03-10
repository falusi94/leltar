# frozen_string_literal: true

describe '/api/users' do
  let(:url) { '/api/users' }

  describe 'GET #index' do
    let(:resources) { User.all }

    include_examples 'API lists resources'
  end

  describe 'GET #show' do
    let(:resource) { create(:user) }

    include_examples 'API shows resource'
  end

  describe 'POST #create' do
    let(:params)   { attributes_for(:user) }
    let(:resource) { User.last }

    include_examples 'API creates resource'
  end

  describe 'PUT #update' do
    let(:params)           { { name: 'New name' } }
    let(:incorrect_params) { { name: '' } }
    let(:resource)         { create(:user) }

    include_examples 'API updates resource'
  end

  describe 'DELETE #destroy' do
    let(:resource) { create(:user) }

    include_examples 'API deletes resource'
  end
end
