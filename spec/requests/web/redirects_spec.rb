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

    context 'when the has no access to any department' do
      it 'shows unauthorized' do
        login

        redirect

        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when the has access to one department' do
      it "redirects to the department's items" do
        department = create(:department)
        user       = create(:user, departments: [department])
        login(user)

        redirect

        expect(response).to redirect_to("/departments/#{department.id}/items")
      end
    end

    context 'when the has access to more than one department' do
      it 'redirects to the items page' do
        departments = create_list(:department, 2)
        user        = create(:user, departments: departments)
        login(user)

        redirect

        expect(response).to redirect_to('/items')
      end
    end
  end
end
