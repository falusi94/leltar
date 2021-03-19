# frozen_string_literal: true

describe 'SystemAttributes' do
  describe 'GET #edit' do
    subject(:edit_status) { get '/system_attributes/edit' }

    include_examples 'without user redirects to login'

    context 'when the user is logged in' do
      it 'returns edit status' do
        login_admin

        edit_status

        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe 'POST #update' do
    subject(:update_status) { put '/system_attributes', params: { key: 'value' } }

    include_examples 'without user redirects to login'

    context 'when the user is logged in' do
      before { login_admin }

      context 'and the attribute exists' do
        it 'updates it' do
          system_attribute = create(:system_attribute, name: 'key')

          update_status

          expect(response).to redirect_to(status_index_path)
          expect(system_attribute.reload).to have_attributes(value: 'value')
        end
      end

      context 'and the attribute does not exist' do
        it 'does nothing' do
          expect { update_status }.not_to change(SystemAttribute, :count)

          expect(response).to redirect_to(status_index_path)
        end
      end
    end
  end
end
