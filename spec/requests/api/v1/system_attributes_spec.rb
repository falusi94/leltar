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

    context 'when the attribute exists' do
      let(:system_attribute) { create(:system_attribute) }
      let(:params) { { system_attribute.name => 'value' } }

      it 'updates it' do
        update_system_attributes

        expect(response).to have_http_status(:ok)
        expect(response.headers).to include('access-token')
        expect(system_attribute.reload).to have_attributes(value: 'value')
      end
    end

    context 'when the attribute does exist' do
      let(:params) { { name: 'non-existing', value: 'value' } }

      it 'does not create it' do
        expect { update_system_attributes }.not_to change(SystemAttribute, :count)
      end
    end

    context 'when the user is not authorized' do
      subject(:update_system_attributes) { get '/api/system_attributes', headers: api_headers }

      include_examples 'API returns unauthorized'
    end
  end
end
