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
  end
end
