# frozen_string_literal: true

describe 'Users' do
  shared_examples 'without user redirects to login' do
    context 'when there is no user' do
      it 'redirects to login' do
        subject

        expect(response).to have_http_status(:found).and redirect_to(new_session_path)
      end
    end
  end

  describe 'GET #index' do
    subject(:get_users) { get '/users' }

    include_examples 'without user redirects to login'

    it 'returns the users' do
      user = create(:admin)
      login(user)

      get_users

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(user.name)
    end
  end

  describe 'GET #show' do
    subject(:get_user) { get "/users/#{user.id}" }

    let(:user) { create(:admin) }

    include_examples 'without user redirects to login'

    it 'returns the user' do
      login(user)

      get_user

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(user.name)
    end
  end

  describe 'GET #new' do
    subject(:get_new_user) { get '/users/new' }

    let(:user) { create(:admin) }

    include_examples 'without user redirects to login'

    it 'returns the new user' do
      login(user)

      get_new_user

      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET #edit' do
    subject(:get_edit_user) { get "/users/#{user.id}/edit" }

    let(:user) { create(:admin) }

    include_examples 'without user redirects to login'

    it 'returns the user edit page' do
      login(user)

      get_edit_user

      expect(response).to have_http_status(:ok)
      expect(response.body).to include(user.name)
    end
  end

  describe 'POST #create' do
    subject(:create_user) { post '/users', params: { user: attributes_for(:user) } }

    let(:user) { create(:admin) }

    include_examples 'without user redirects to login'

    # TODO: fix SQLite id
    xit 'creates the user' do
      login(user)

      expect { create_user }.to change(User, :count).by(1)

      expect(response).to have_http_status(:create)
    end
  end

  describe 'PUT #update' do
    subject(:update_user) { put "/users/#{user.id}", params: { user: { name: 'new name' } } }

    let(:user) { create(:admin) }

    include_examples 'without user redirects to login'

    it 'updates the user' do
      login(user)

      update_user

      expect(response).to have_http_status(:found)
      expect(user.reload).to have_attributes(name: 'new name')
    end
  end

  describe 'DELETE #destroy' do
    subject(:delete_user) { delete "/users/#{user.id}" }

    let(:user) { create(:admin) }

    include_examples 'without user redirects to login'

    it 'deletes the user' do
      login(user)

      expect { delete_user }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:found)
    end
  end
end
