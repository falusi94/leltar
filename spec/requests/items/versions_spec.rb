# frozen_string_literal: true

describe 'Item versions' do
  describe 'GET #show' do
    subject(:get_version) { get "/items/#{item.id}/versions/1" }

    let(:item) { create(:item) }

    include_examples 'without user redirects to login'

    it 'returns the version' do
      login_admin

      item.update!(name: 'New item name') # TODO: imrpove version creation in test

      get_version

      expect(response).to have_http_status(:ok)
    end
  end
end
