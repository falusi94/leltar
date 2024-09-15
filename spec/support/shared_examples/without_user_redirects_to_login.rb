# frozen_string_literal: true

shared_examples 'without user redirects to login' do
  context 'when there is no user' do
    it 'redirects to login' do
      subject

      redirect_url = Organization.any? ? new_session_path : new_setup_user_path

      expect(response).to have_http_status(:found).and redirect_to(redirect_url)
    end
  end
end
