# frozen_string_literal: true

describe 'Invoices' do
  describe 'create invoice' do
    subject(:create_invoice) do
      file = Rack::Test::UploadedFile.new('spec/fixtures/files/dot.jpg', 'image/jpg')

      post "/items/#{item.id}/invoices", params: { photo: file }
    end

    let(:item) { create(:item) }

    include_examples 'without user redirects to login'

    context 'when the user can write group' do
      it 'attaches the invoice' do
        login_admin

        create_invoice

        expect(response).to redirect_to(edit_item_path(item))
        expect(item.reload.invoice).to be_present
      end
    end
  end

  describe 'delete invoice' do
    subject(:delete_invoice) { delete "/items/#{item.id}/invoices/#{item.invoice.id}" }

    let(:item) { create(:item, :with_invoice) }

    include_examples 'without user redirects to login'

    context 'when the user can write group' do
      it 'deletes the invoice' do
        login_admin

        delete_invoice

        expect(response).to redirect_to(edit_item_path(item))
        expect(item.reload.invoice).to be_blank
      end
    end
  end
end
