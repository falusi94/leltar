# frozen_string_literal: true

describe 'Invoices' do
  describe 'create invoice' do
    subject(:create_invoice) do
      post "/org/#{item.organization.slug}/items/#{item.id}/invoice", params: { photo: photo }
    end

    let(:photo) { fixture_file_upload('dot.jpg', 'image/jpeg') }
    let(:item)  { create(:item) }

    include_examples 'without user redirects to login'

    context 'when the user can write department' do
      it 'attaches the invoice' do
        login_admin

        create_invoice

        expect(response).to redirect_to(edit_item_path(item))
        expect(item.reload.invoice).to be_present
      end
    end
  end

  describe 'delete invoice' do
    subject(:delete_invoice) { delete "/org/#{item.organization.slug}/items/#{item.id}/invoice" }

    let(:item) { create(:item, :with_invoice) }

    include_examples 'without user redirects to login'

    context 'when the user can write department' do
      it 'deletes the invoice' do
        login_admin

        delete_invoice

        expect(response).to redirect_to(edit_item_path(item))
        expect(item.reload.invoice).to be_blank
      end
    end
  end
end
