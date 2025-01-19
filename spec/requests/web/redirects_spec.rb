# frozen_string_literal: true

describe 'Redirects' do
  describe 'GET #show' do
    subject(:redirect) { get '/' }

    it 'redirects using the RedirectUrl' do
      allow(RedirectUrl).to receive(:generate).and_call_original
      login_admin

      redirect

      expect(response).to redirect_to('/setup/users/new')
      expect(RedirectUrl).to have_received(:generate)
    end
  end
end
