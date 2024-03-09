# frozen_string_literal: true

describe '/api/groups' do
  let(:url) { '/api/groups' }

  describe 'GET #index' do
    let(:resources) { create_list(:group, 1) }

    include_examples 'API lists resources'
  end

  describe 'GET #show' do
    let(:resource) { create(:group) }

    include_examples 'API shows resource'
  end

  describe 'POST #create' do
    let(:params)   { attributes_for(:group) }
    let(:resource) { Group.first }

    include_examples 'API creates resource'
  end

  describe 'PUT #update' do
    let(:params)           { { name: 'New name' } }
    let(:incorrect_params) { { name: '' } }
    let(:resource)         { create(:group) }

    include_examples 'API updates resource'
  end

  describe 'DELETE #destroy' do
    let(:resource) { create(:group) }

    include_examples 'API deletes resource'
  end
end
