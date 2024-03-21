# frozen_string_literal: true

describe '/api/items' do
  let(:url) { '/api/items' }

  describe 'GET #index' do
    let(:resources) { create_list(:item, 1) }

    before { allow(ItemsQuery).to receive(:fetch).and_call_original }

    include_examples 'API lists resources'

    describe 'nested path' do
      let(:url) { "/api/departments/#{resources.first.department_id}/items" }

      include_examples 'API lists resources'
    end
  end

  describe 'GET #show' do
    let(:resource) { create(:item) }

    include_examples 'API shows resource'
  end

  describe 'POST #create' do
    let(:url)      { "/api/departments/#{create(:department).id}/items" }
    let(:params)   { attributes_for(:item) }
    let(:resource) { Item.first }

    include_examples 'API creates resource'

    context 'when the department does not exist' do
      subject(:create_item) { post '/api/departments/non-existing/items', headers: auth_headers(user) }

      let(:user) { create(:admin, :with_session) }

      include_examples 'API returns not found'
    end
  end

  describe 'PUT #update' do
    let(:params)           { { name: 'New name' } }
    let(:incorrect_params) { { name: '' } }
    let(:resource)         { create(:item) }

    include_examples 'API updates resource'
  end

  describe 'DELETE #destroy' do
    let(:resource) { create(:item) }

    include_examples 'API deletes resource'
  end
end
