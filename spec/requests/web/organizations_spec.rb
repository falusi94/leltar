# frozen_string_literal: true

describe 'Organizations' do
  let!(:organization) { create(:organization) }

  describe 'GET #index' do
    subject(:get_organizations) { get "/org/#{organization.slug}/organizations" }

    include_examples 'without user redirects to login'

    it 'returns the organizations' do
      organization = create(:organization)
      login_admin

      get_organizations

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(organization.name)
    end
  end

  describe 'GET #new' do
    subject(:get_new_organization) { get "/org/#{organization.slug}/organizations/new" }

    include_examples 'without user redirects to login'

    it 'returns the new organization' do
      login_admin

      get_new_organization

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #edit' do
    subject(:get_edit_organization) { get "/org/#{organization.slug}/organizations/#{organization.slug}/edit" }

    include_examples 'without user redirects to login'

    it 'returns the organization edit page' do
      login_admin

      get_edit_organization

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(organization.name)
    end
  end

  describe 'POST #create' do
    subject(:create_organization) do
      post "/org/#{organization.slug}/organizations", params: { organization: attributes_for(:organization) }
    end

    include_examples 'without user redirects to login'

    it 'creates the organization' do
      login_admin

      expect { create_organization }.to change(Organization, :count).by(1)

      expect(response).to have_http_status(:found).and redirect_to(organizations_path)
    end
  end

  describe 'PUT #update' do
    subject(:update_organization) do
      put "/org/#{organization.slug}/organizations/#{organization.slug}", params: { organization: { name: 'new name' } }
    end

    include_examples 'without user redirects to login'

    it 'updates the organization' do
      login_admin

      update_organization

      expect(response).to have_http_status(:found)
      expect(organization.reload).to have_attributes(name: 'new name')
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_organization) { delete "/org/#{organization.slug}/organizations/#{other_organization.slug}" }

    let!(:other_organization) { create(:organization) }

    include_examples 'without user redirects to login'

    it 'deletes the organization' do
      login_admin

      expect { delete_organization }.to change(Organization, :count).by(-1)

      expect(response).to have_http_status(:found)
    end
  end
end
