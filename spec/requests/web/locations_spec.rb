# frozen_string_literal: true

describe 'Locations' do
  let(:organization) { create(:organization) }

  describe 'GET #index' do
    subject(:get_locations) { get "/org/#{organization.slug}/locations" }

    include_examples 'without user redirects to login'

    it 'returns the locations' do
      location = create(:location, organization: organization)
      login_admin

      get_locations

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(location.name)
    end
  end

  describe 'GET #new' do
    subject(:get_new_location) { get "/org/#{organization.slug}/locations/new" }

    include_examples 'without user redirects to login'

    it 'returns the new location' do
      login_admin

      get_new_location

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #edit' do
    subject(:get_edit_location) { get "/org/#{organization.slug}/locations/#{location.id}/edit" }

    let(:location) { create(:location, organization: organization) }

    include_examples 'without user redirects to login'

    it 'returns the location edit page' do
      login_admin

      get_edit_location

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(location.name)
    end
  end

  describe 'POST #create' do
    subject(:create_location) do
      post "/org/#{organization.slug}/locations", params: { location: location_params }
    end

    let(:location_params) { attributes_for(:location) }

    include_examples 'without user redirects to login'

    it 'creates the location' do
      login_admin

      expect { create_location }.to change(Location, :count).by(1)

      expect(response).to have_http_status(:found).and redirect_to("/org/#{organization.slug}/locations")
      expect(Location.last).to have_attributes(location_params)
    end
  end

  describe 'PUT #update' do
    subject(:update_location) do
      put "/org/#{organization.slug}/locations/#{location.id}", params: { location: { name: 'new name' } }
    end

    let(:location) { create(:location, organization: organization) }

    include_examples 'without user redirects to login'

    it 'updates the location' do
      login_admin

      update_location

      expect(response).to have_http_status(:found)
      expect(location.reload).to have_attributes(name: 'new name')
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_location) { delete "/org/#{organization.slug}/locations/#{location.id}" }

    let!(:location) { create(:location, organization: organization) }

    include_examples 'without user redirects to login'

    it 'deletes the location' do
      login_admin

      expect { delete_location }.to change(Location, :count).by(-1)

      expect(response).to have_http_status(:found)
    end
  end
end
