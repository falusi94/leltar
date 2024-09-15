# frozen_string_literal: true

describe 'Users' do
  describe 'GET #new' do
    subject(:get_new_user) { get '/setup/users/new' }

    it 'returns the new user' do
      get_new_user

      expect(response).to have_http_status(:ok)
    end

    context 'when there is an organization' do
      before { create(:organization) }

      it 'redirects to the root path' do
        get_new_user

        expect(response).to have_http_status(:found).and redirect_to('/')
      end
    end
  end

  describe 'POST #create' do
    subject(:create_user) { post '/setup/users', params: { user: attributes_for(:user) } }

    it 'creates the user' do
      expect { create_user }.to change(User, :count).by(1)

      expect(response).to have_http_status(:found).and redirect_to('/setup/organizations/new')
      expect(session[:user_id]).to eq(User.last.id)
    end

    it 'logs in the user' do
      create_user

      expect(session[:user_id]).to eq(User.last.id)
    end

    context 'when there is an organization' do
      before { create(:organization) }

      it 'redirects to the root path' do
        expect { create_user }.not_to change(User, :count)

        expect(response).to have_http_status(:found).and redirect_to('/')
      end

      it 'does not log in the user' do
        create_user

        expect(session[:user_id]).to be(nil)
      end
    end
  end
end
