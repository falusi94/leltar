# frozen_string_literal: true

describe 'Sessions' do
  describe 'GET #new' do
    it 'returns the login page' do
      get '/session/new'

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Email')
    end
  end

  describe 'POST #create' do
    context 'when invalid params are passed' do
      it 'does not log in the user' do
        post '/session/create', params: { session: { email: 'user@example.org', password: 'ANYTHING' } }

        expect(response).to have_http_status(:found).and redirect_to('/session/new')
        follow_redirect!

        expect(response.body).to include('Hibás bejelentkezési adatok')
      end
    end

    context 'when valid params are passed' do
      it 'logs in the user' do
        user = create(:user)

        post '/session/create', params: { session: { email: user.email, password: 'password' } }

        expect(response).to have_http_status(:found).and redirect_to('/')
        expect(session[:user_id]).to eq(user.id)
      end
    end
  end

  describe 'GET #destroy' do
    it 'logs out the user' do
      login

      get '/session/destroy'

      expect(session[:user_id]).to be_blank
    end
  end

  describe 'GET #smart_redirect' do
    subject(:smart_redirect) { get '/' }

    context 'when the user is admin' do
      it 'redirects to the items page' do
        login(create(:admin))

        smart_redirect

        expect(response).to redirect_to('/items')
      end
    end
  end
end
