# frozen_string_literal: true

describe '/crono' do
  include WebHelpers

  subject(:get_status) { get '/crono' }

  context 'when the user is not logged in' do
    it 'raises a routing error' do
      expect { get_status }.to raise_error(ActionController::RoutingError)
    end
  end

  context 'when the user is logged in' do
    it 'returns the page' do
      login_admin

      get_status

      expect(response).to have_http_status(:ok)
    end
  end
end
