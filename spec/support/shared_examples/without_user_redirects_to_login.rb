# frozen_string_literal: true

shared_examples 'without user redirects to login' do
  context 'when there is no user' do
    it 'redirects to login' do
      subject

      expect(response).to have_http_status(:found).and redirect_to(new_session_path)
    end
  end
end
