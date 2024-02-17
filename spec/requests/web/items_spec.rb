# frozen_string_literal: true

describe 'Items' do
  describe 'GET #index' do
    subject(:show_items) { get '/items' }

    let!(:item) { create(:item) }

    include_examples 'without user redirects to login'

    context 'when the user is logged in' do
      before { login_admin }

      it 'returns the list of items' do
        show_items

        expect(response).to have_http_status(:ok)
        expect(body).to include(item.name)
      end

      it 'uses ItemsQuery for result' do
        allow(ItemsQuery).to receive(:fetch).and_call_original

        show_items

        expect(ItemsQuery).to have_received(:fetch).with(ActionController::Parameters, scope: ActiveRecord::Relation)
      end
    end
  end

  describe 'GET #show' do
    subject(:show_item) { get "/items/#{item.id}" }

    let(:item) { create(:item) }

    include_examples 'without user redirects to login'

    context 'when the user has access to the item' do
      it 'shows it' do
        login_admin

        show_item

        expect(response).to have_http_status(:ok)
        expect(body).to include(item.name)
      end
    end
  end

  describe 'GET #new' do
    subject(:new_item) { get '/items/new' }

    include_examples 'without user redirects to login'

    context 'when the user has access to any group' do
      it 'shows it' do
        login_admin
        create(:group)

        new_item

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the user does not have access to any groups' do
      it 'returns unauthorized' do
        login_admin

        new_item

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET #edit' do
    subject(:edit_item) { get "/items/#{item.id}/edit" }

    let(:item) { create(:item) }

    include_examples 'without user redirects to login'

    context 'when the user has access to the group of the item' do
      it 'shows it' do
        login_admin

        edit_item

        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the user does not have to the group of the item' do
      it 'returns unauthorized' do
        login

        edit_item

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'POST #create' do
    subject(:create_item) { post '/items', params: { item: { group_id: group.id, name: 'Item' } } }

    let(:group) { create(:group) }

    include_examples 'without user redirects to login'

    context 'when the user has access to the group' do
      it 'creates it' do
        login_admin

        expect { create_item }.to change(Item, :count).by(1)

        item = Item.last
        expect(response).to redirect_to(item)
        expect(item).to have_attributes(group: group, name: 'Item')
      end
    end

    context 'when the user does not have to the group' do
      it 'does not create it' do
        login

        expect { create_item }.not_to change(Item, :count)

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'PUT #edit' do
    subject(:update_item) { put "/items/#{item.id}", params: { item: { name: 'New name' } } }

    let(:item) { create(:item) }

    include_examples 'without user redirects to login'

    context 'when the user has access to the group' do
      before { login_admin }

      it 'updates it' do
        update_item

        item = Item.last
        expect(response).to redirect_to(item)
        expect(item).to have_attributes(name: 'New name')
      end

      context 'and the update param is set' do
        it 'updates the status of the item' do
          put "/items/#{item.id}", params: { item: { update: true, condition: 'end_of_life' } }

          expect(Item.last).to be_condition_end_of_life.and have_attributes(last_check: be_present)
        end
      end
    end

    context 'when the user does not have to the group' do
      it 'does not update it' do
        login

        update_item

        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
