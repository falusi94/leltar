# frozen_string_literal: true

describe 'Item versions' do
  describe 'GET #show' do
    subject(:get_version) { get "/org/#{item.organization.slug}/items/#{item.id}/versions/1" }

    let(:item) { create(:item) }

    include_examples 'without user redirects to login'

    it 'returns the version' do
      login_admin

      item.update!(name: 'New item name') # TODO: improve version creation in test

      get_version

      expect(response).to have_http_status(:ok)
    end

    context 'when the initial version is requested (nil version)' do
      it 'returns not found' do
        login_admin

        get "/org/#{item.organization.slug}/items/#{item.id}/versions/0"

        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
