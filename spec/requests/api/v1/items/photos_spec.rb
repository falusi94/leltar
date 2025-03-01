# frozen_string_literal: true

describe '/api/organization/:organization_id//items/:item_id/photos' do
  let(:user) { create(:admin, :with_session) }
  let(:item) { create(:item) }

  describe 'GET #index' do
    subject(:list_photos) do
      get "/api/organizations/#{item.organization.id}/items/#{item_id}/photos", headers: auth_headers(user)
    end

    context 'when the item exists' do
      let(:item_id) { item.id }

      context 'and photos' do
        let(:item) { create(:item, :with_photo) }

        it 'returns them' do
          list_photos

          expect(response).to have_http_status(:ok)
          expect(response.headers).to include('authorization')
          expect(json).to match_api_response([item.photos.first])
        end
      end

      context 'and has no photos' do
        it 'returns an empty array' do
          list_photos

          expect(response).to have_http_status(:ok)
          expect(response.headers).to include('authorization')
          expect(json).to match_api_response([])
        end
      end
    end

    context 'when the item does not exist' do
      let(:item_id) { 'non-existing' }

      include_examples 'API returns not found'
    end

    context 'when the user is not authorized' do
      subject(:list_photos) do
        get "/api/organizations/#{item.organization.id}/items/whatever/photos", headers: api_headers
      end

      include_examples 'API returns unauthorized'
    end
  end

  describe 'POST #create' do
    subject(:create_photo) do
      post "/api/organizations/#{item.organization.id}/items/#{item_id}/photos",
           headers: auth_headers(user), params: { photo: photo }
    end

    let(:photo) { fixture_file_upload('dot.jpg', 'image/jpeg') }

    context 'when the item exists' do
      let(:item_id) { item.id }

      it 'attaches the photo' do
        expect { create_photo }.to change(item.photos, :count).by(1)
      end
    end

    context 'when the item does not exist' do
      let(:item_id) { 'non-existing' }

      include_examples 'API returns not found'
    end

    context 'when the user is not authorized' do
      subject(:create_photos) do
        post "/api/organizations/#{item.organization.id}/items/whatever/photos", headers: api_headers
      end

      include_examples 'API returns unauthorized'
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_photo) do
      delete "/api/organizations/#{item.organization.id}/items/#{item_id}/photos/#{photo_id}",
             headers: auth_headers(user)
    end

    let!(:item) { create(:item, :with_photo) }

    context 'when the item and the photo exist' do
      let(:item_id) { item.id }
      let(:photo_id) { item.photos.ids.first }

      it 'removes the photo' do
        expect { delete_photo }.to change(item.photos, :count).by(-1)
      end
    end

    context 'when the photo does not exist' do
      let(:item_id) { item.id }
      let(:photo_id) { 'non-existing' }

      include_examples 'API returns not found'
    end

    context 'when the item does not exist' do
      let(:item_id) { 'non-existing' }
      let(:photo_id) { 'whatever' }

      include_examples 'API returns not found'
    end

    context 'when the user is not authorized' do
      subject(:delete_photos) do
        delete "/api/organizations/#{item.organization.id}/items/whatever/photos/whatever", headers: api_headers
      end

      include_examples 'API returns unauthorized'
    end
  end
end
