# frozen_string_literal: true

describe 'Organizations' do
  describe 'GET #new' do
    subject(:get_new_organization) { get '/setup/organizations/new' }

    it 'returns the new organization' do
      get_new_organization

      expect(response).to have_http_status(:ok)
    end

    context 'when there is an organization' do
      before { create(:organization) }

      it 'redirects to the root path' do
        get_new_organization

        expect(response).to have_http_status(:found).and redirect_to('/')
      end
    end
  end

  describe 'POST #create' do
    subject(:create_organization) do
      post '/setup/organizations', params: { organization: attributes_for(:organization) }
    end

    it 'creates the organization' do
      expect { create_organization }.to change(Organization, :count).by(1)

      expect(response).to have_http_status(:found).and redirect_to('/')
    end

    context 'when there is an organization' do
      before { create(:organization) }

      it 'redirects to the root path' do
        expect { create_organization }.not_to change(Organization, :count)

        expect(response).to have_http_status(:found).and redirect_to('/')
      end
    end
  end
end
