# frozen_string_literal: true

describe 'Groups' do
  def login_admin
    user = create(:admin)
    login(user)
  end

  describe 'GET #index' do
    subject(:get_groups) { get '/groups' }

    include_examples 'without user redirects to login'

    it 'returns the groups' do
      group = create(:group)
      login_admin

      get_groups

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(group.name)
    end
  end

  describe 'GET #new' do
    subject(:get_new_group) { get '/groups/new' }

    include_examples 'without user redirects to login'

    it 'returns the new group' do
      login_admin

      get_new_group

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #edit' do
    subject(:get_edit_group) { get "/groups/#{group.id}/edit" }

    let(:group) { create(:group) }

    include_examples 'without user redirects to login'

    it 'returns the group edit page' do
      login_admin

      get_edit_group

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(group.name)
    end
  end

  describe 'POST #create' do
    subject(:create_group) { post '/groups', params: { group: attributes_for(:group) } }

    include_examples 'without user redirects to login'

    it 'creates the group' do
      login_admin

      expect { create_group }.to change(Group, :count).by(1)

      expect(response).to have_http_status(:found).and redirect_to("/groups/#{Group.last.id}/items")
    end
  end

  describe 'PUT #update' do
    subject(:update_group) { put "/groups/#{group.id}", params: { group: { name: 'new name' } } }

    let(:group) { create(:group) }

    include_examples 'without user redirects to login'

    it 'updates the group' do
      login_admin

      update_group

      expect(response).to have_http_status(:found)
      expect(group.reload).to have_attributes(name: 'new name')
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_group) { delete "/groups/#{group.id}" }

    let!(:group) { create(:group) }

    include_examples 'without user redirects to login'

    it 'deletes the group' do
      login_admin

      expect { delete_group }.to change(Group, :count).by(-1)

      expect(response).to have_http_status(:found)
    end
  end
end
