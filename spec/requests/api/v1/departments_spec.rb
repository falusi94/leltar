# frozen_string_literal: true

describe '/api/departments' do
  let(:url) { '/api/departments' }

  describe 'GET #index' do
    let(:resources) { create_list(:department, 1) }

    include_examples 'API lists resources'
  end

  describe 'GET #show' do
    let(:resource) { create(:department) }

    include_examples 'API shows resource'
  end

  describe 'POST #create' do
    let(:params)   { attributes_for(:department) }
    let(:resource) { Department.first }

    include_examples 'API creates resource'
  end

  describe 'PUT #update' do
    let(:params)           { { name: 'New name' } }
    let(:incorrect_params) { { name: '' } }
    let(:resource)         { create(:department) }

    include_examples 'API updates resource'
  end

  describe 'DELETE #destroy' do
    let(:resource) { create(:department) }

    include_examples 'API deletes resource'
  end
end
