# frozen_string_literal: true

describe Api::V1::BaseController do # rubocop:disable RSpec/SpecFilePathFormat
  before do
    stub_const('TestController', Class.new(described_class) do
      skip_before_action :authenticate_user!
      skip_after_action :verify_authorized

      def error
        raise params[:error].constantize
      end

      def requires_login
        authenticate_user!
      end
    end)

    Rails.application.routes.draw do
      get '/error' => 'test#error'
      get '/requires_login' => 'test#requires_login'
    end
  end

  after { Rails.application.reload_routes! }

  context 'when ActiveRecord::RecordNotFound raised' do
    it 'returns the not found' do
      get '/error', params: { error: 'ActiveRecord::RecordNotFound' }

      expect(response).to have_http_status(:not_found)
    end
  end

  context 'when Pundit::NotAuthorizedError raised' do
    it 'returns the forbidden' do
      get '/error', params: { error: 'Pundit::NotAuthorizedError' }

      expect(response).to have_http_status(:forbidden)
    end
  end

  context 'when no user exists' do
    it 'returns unauthorized' do
      get '/requires_login'

      expect(response).to have_http_status(:unauthorized)
    end
  end
end
