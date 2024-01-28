# frozen_string_literal: true

describe 'Redirects' do
  describe 'GET #show' do
    subject(:redirect) { get '/' }

    context 'when the user is admin' do
      it 'redirects to the items page' do
        login(create(:admin))

        redirect

        expect(response).to redirect_to('/items')
      end
    end

    context 'when the has no access to any group' do
      it 'shows unauthorized' do
        login

        redirect

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the has access to one group' do
      it "redirects to the group's items" do
        group = create(:group)
        user  = create(:user, groups: [group])
        login(user)

        redirect

        expect(response).to redirect_to("/groups/#{group.id}/items")
      end
    end

    context 'when the has access to more than one group' do
      it 'redirects to the items page' do
        groups = create_list(:group, 2)
        user   = create(:user, groups: groups)
        login(user)

        redirect

        expect(response).to redirect_to('/items')
      end
    end
  end
end
