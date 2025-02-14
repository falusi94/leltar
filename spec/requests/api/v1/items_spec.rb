# frozen_string_literal: true

describe '/api/organization/:organization_id/items' do
  let(:organization) { create(:organization) }
  let(:url)          { "/api/organizations/#{organization.id}/items" }

  describe 'GET #index' do
    let(:resources) { create_list(:item, 1, organization: organization) }

    before { allow(ItemsQuery).to receive(:fetch).and_call_original }

    include_examples 'API lists resources'

    describe 'nested path' do
      let(:url) { "/api/organizations/#{organization.id}/departments/#{resources.first.department_id}/items" }

      include_examples 'API lists resources'
    end
  end

  describe 'GET #show' do
    let(:resource) { create(:item, organization: organization) }

    include_examples 'API shows resource'
  end

  describe 'POST #create' do
    let(:url) do
      "/api/organizations/#{organization.id}/departments/#{create(:department, organization: organization).id}/items"
    end
    let(:params)   { attributes_for(:item) }
    let(:resource) { Item.first }

    include_examples 'API creates resource'

    context 'when the department does not exist' do
      subject(:create_item) do
        post "/api/organizations/#{organization.id}/departments/non-existing/items", headers: auth_headers(user)
      end

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
