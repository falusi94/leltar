# frozen_string_literal: true

describe Web::BaseController do # rubocop:disable RSpec/SpecFilePathFormat
  before do
    stub_const('TestController', Class.new(described_class) do
      skip_before_action :require_login

      layout false

      def error
        raise params[:error].constantize
      end

      def requires_login
        require_login
      end
    end)

    Rails.application.routes.draw do
      get '/error' => 'test#error'
      get '/requires_login' => 'test#requires_login'

      namespace :setup do
        resources :users, only: %i[new]
      end
    end
  end

  after { Rails.application.reload_routes! }

  context 'when ActiveRecord::RecordNotFound raised' do
    it 'returns the not found page' do
      get '/error', params: { error: 'ActiveRecord::RecordNotFound' }

      expect(response).to have_http_status(:not_found)
      expect(body).to include(I18n.t(:not_found))
    end
  end

  context 'when Pundit::NotAuthorizedError raised' do
    it 'returns the unauthorized page' do
      get '/error', params: { error: 'Pundit::NotAuthorizedError' }

      expect(response).to have_http_status(:unauthorized)
      expect(body).to include(I18n.t(:unauthorized))
    end
  end

  context 'when no user exists' do
    it 'redirects to the setup page' do
      get '/requires_login'

      expect(response).to redirect_to('/setup/users/new')
    end
  end
end
