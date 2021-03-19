# frozen_string_literal: true

describe 'Status' do
  describe 'GET #index' do
    subject(:get_status) { get '/status' }

    include_examples 'without user redirects to login'

    context 'when the user is logged in' do
      it 'returns the status' do
        login_admin

        get_status

        expect(response).to have_http_status(:ok)
      end
    end
  end
end
