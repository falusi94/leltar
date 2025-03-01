# frozen_string_literal: true

describe '/api/organization/:organization_id//items/:item_id/invoice' do
  let(:user) { create(:admin, :with_session) }
  let(:item) { create(:item) }

  describe 'GET #show' do
    subject(:show_invoice) do
      get "/api/organizations/#{item.organization.id}/items/#{item_id}/invoice", headers: auth_headers(user)
    end

    context 'when the item exists' do
      let(:item_id) { item.id }

      context 'and invoice' do
        let(:item) { create(:item, :with_invoice) }

        it 'returns them' do
          show_invoice

          expect(response).to have_http_status(:ok)
          expect(response.headers).to include('authorization')
          expect(json).to match_api_response(api_attachment_hash(item.invoice))
        end
      end

      context 'and has no invoice' do
        include_examples 'API returns not found'
      end
    end

    context 'when the item does not exist' do
      let(:item_id) { 'non-existing' }

      include_examples 'API returns not found'
    end

    context 'when the user is not authorized' do
      subject(:list_invoice) do
        get "/api/organizations/#{item.organization.id}/items/whatever/invoice", headers: api_headers
      end

      include_examples 'API returns unauthorized'
    end
  end

  describe 'POST #create' do
    subject(:create_invoice) do
      post "/api/organizations/#{item.organization.id}/items/#{item_id}/invoice",
           headers: auth_headers(user), params: { photo: photo }
    end

    let(:photo) { fixture_file_upload('dot.jpg', 'image/jpeg') }

    context 'when the item exists' do
      let(:item_id) { item.id }

      it 'attaches the invoice' do
        create_invoice

        expect(item.reload.invoice).to be_present
      end
    end

    context 'when the item does not exist' do
      let(:item_id) { 'non-existing' }

      include_examples 'API returns not found'
    end

    context 'when the user is not authorized' do
      subject(:create_invoice) do
        post "/api/organizations/#{item.organization.id}/items/whatever/invoice", headers: api_headers
      end

      include_examples 'API returns unauthorized'
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_invoice) do
      delete "/api/organizations/#{item.organization.id}/items/#{item_id}/invoice", headers: auth_headers(user)
    end

    let(:item) { create(:item, :with_invoice) }

    context 'when the item and the invoice exist' do
      let(:item_id) { item.id }

      it 'removes the invoice' do
        delete_invoice

        expect(item.reload.invoice).not_to be_present
      end
    end

    context 'when the invoice does not exist' do
      let(:item_id) { item.id }
      let(:item) { create(:item) }

      include_examples 'API returns not found'
    end

    context 'when the item does not exist' do
      let(:item_id) { 'non-existing' }

      include_examples 'API returns not found'
    end

    context 'when the user is not authorized' do
      subject(:delete_invoice) do
        delete "/api/organizations/#{item.organization.id}/items/whatever/invoice", headers: api_headers
      end

      include_examples 'API returns unauthorized'
    end
  end
end
