# frozen_string_literal: true

describe 'Photos' do
  describe 'create photo' do
    subject(:create_photo) { post "/items/#{item.id}/photos", params: { photo: photo } }

    let(:photo) { fixture_file_upload('dot.jpg', 'image/jpeg') }
    let(:item) { create(:item) }

    include_examples 'without user redirects to login'

    context 'when the user can write department' do
      it 'attaches the photo' do
        login_admin

        create_photo

        expect(response).to redirect_to(edit_item_path(item))
        expect(item.reload.photos).to be_present
      end
    end
  end

  describe 'delete photo' do
    subject(:delete_photo) { delete "/items/#{item.id}/photos/#{item.photos.first.id}" }

    let(:item) { create(:item, :with_photo) }

    include_examples 'without user redirects to login'

    context 'when the user can write department' do
      it 'deletes the photo' do
        login_admin

        delete_photo

        expect(response).to redirect_to(edit_item_path(item))
        expect(item.reload.photos).to be_blank
      end
    end
  end
end
