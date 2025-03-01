# frozen_string_literal: true

describe '/api/system_attributes' do
  let(:url) { '/api/system_attributes' }

  describe 'GET #index' do
    let(:resources) { [create(:new_session_start_attribute)] }

    include_examples 'API lists resources'
  end

  describe 'PUT #update' do
    subject(:update_system_attributes) { put '/api/system_attributes', headers: auth_headers(user), params: params }

    let(:user) { create(:admin, :with_session) }
    let(:system_attribute) { create(:system_attribute) }
    let(:params) { { system_attribute.name => 'value' } }

    it 'updates it' do
      allow(SystemAttribute).to receive(:update!).and_call_original

      update_system_attributes

      expect(response).to have_http_status(:ok)
      expect(response.headers).to include('authorization')
      expect(system_attribute.reload).to have_attributes(value: 'value')
      expect(SystemAttribute).to have_received(:update!)
    end

    context 'when the user is not authorized' do
      subject(:update_system_attributes) { get '/api/system_attributes', headers: api_headers }

      include_examples 'API returns unauthorized'
    end
  end
end
