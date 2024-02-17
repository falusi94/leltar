# frozen_string_literal: true

describe '/api/session' do
  describe 'POST #create' do
    subject(:session_create) { post('/api/session', params: params, headers: api_headers) }

    let(:user) { create(:user) }

    context 'when the user exists' do
      let(:params) { { email: user.email, password: 'password' } }

      it 'logs in the user' do
        session_create

        expect(response).to have_http_status(:ok)
        expect(response.headers).to include('access-token')
        expect(json).to match_api_response(user)
      end

      it 'creates a user session' do
        expect { session_create }.to change(UserSession, :count).by(1)

        expect(UserSession.last).to have_attributes(user: user, ip_address: '127.0.0.1', user_agent: nil)
      end
    end

    context 'when the user does not exist' do
      let(:params) { { email: 'non-existing', password: 'password' } }

      it 'returns unauthorized' do
        session_create

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when invalid password is sent' do
      let(:params) { { email: user.email, password: 'invalid' } }

      it 'returns unauthorized' do
        session_create

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'DELETE #destroy' do
    subject(:session_destroy) { delete '/api/session', headers: auth_headers(user) }

    context 'when the user is logged in' do
      let(:user) { create(:user, :with_session) }

      it 'removes the session' do
        session_destroy

        expect(response).to have_http_status(:ok)
        expect(UserSession).not_to exist(user.sessions.first.id)
      end
    end

    context 'when the user is not logged in' do
      let(:user) { create(:user) }

      it 'returns unauthorized' do
        session_destroy

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
