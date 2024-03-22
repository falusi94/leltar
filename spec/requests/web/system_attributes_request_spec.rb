# frozen_string_literal: true

describe 'SystemAttributes' do
  describe 'GET #edit' do
    subject(:edit_system_attributes) { get '/system_attributes/edit' }

    include_examples 'without user redirects to login'

    context 'when the user is logged in' do
      it 'returns edit status' do
        login_admin

        edit_system_attributes

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'PUT #update' do
    subject(:update_system_attributes) { put '/system_attributes', params: params }

    context 'when the user is not authorized' do
      subject(:update_system_attributes) { put '/system_attributes' }

      include_examples 'without user redirects to login'
    end

    context 'when the user is logged in' do
      before { login_admin }

      context 'and the attribute exists' do
        let(:system_attribute) { create(:system_attribute) }
        let(:params) { { system_attribute.name => 'value' } }

        it 'updates it' do
          update_system_attributes

          expect(response).to redirect_to(status_index_path)
          expect(system_attribute.reload).to have_attributes(value: 'value')
        end
      end

      context 'and the attribute does not exist' do
        let(:params) { { name: 'non-existing', value: 'value' } }

        it 'does nothing' do
          expect { update_system_attributes }.not_to change(SystemAttribute, :count)

          expect(response).to redirect_to(status_index_path)
        end
      end
    end
  end
end
