# frozen_string_literal: true

describe 'Status' do
  let(:organization) { create(:organization) }

  describe 'GET #index' do
    subject(:get_status) { get "/org/#{organization.slug}/status" }

    include_examples 'without user redirects to login'

    context 'when the user is logged in' do
      it 'returns the status' do
        login_admin
        allow(Status).to receive(:new).and_call_original

        get_status

        expect(response).to have_http_status(:ok)
        expect(Status).to have_received(:new).with(organization)
      end
    end
  end
end
