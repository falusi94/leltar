# frozen_string_literal: true

describe Web::BaseController do # rubocop:disable RSpec/SpecFilePathFormat
  before do
    stub_const('ErrorController', Class.new(described_class) do
      skip_before_action :require_login

      layout false

      def show
        raise params[:error].constantize
      end
    end)

    Rails.application.routes.draw do
      get '/error' => 'error#show'
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
end
