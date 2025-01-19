# frozen_string_literal: true

describe 'SystemAttributes' do
  let(:organization) { create(:organization) }

  describe 'GET #edit' do
    subject(:edit_system_attributes) { get "/org/#{organization.slug}/system_attributes/edit" }

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
    subject(:update_system_attributes) { put "/org/#{organization.slug}/system_attributes", params: try(:params) }

    context 'when the user is not authorized' do
      include_examples 'without user redirects to login'
    end

    context 'when the user is logged in' do
      before { login_admin }

      let(:system_attribute) { create(:system_attribute) }
      let(:params) { { system_attribute.name => 'value' } }

      it 'updates it' do
        allow(SystemAttribute).to receive(:update!).and_call_original

        update_system_attributes

        expect(response).to redirect_to(edit_system_attributes_path)
        expect(system_attribute.reload).to have_attributes(value: 'value')
        expect(SystemAttribute).to have_received(:update!)
      end
    end
  end
end
