# frozen_string_literal: true

describe Authentication::ModelMixin do
  describe '#api_authenticate' do
    subject(:api_authenticate) { user.api_authenticate(password, user_agent: 'user_agent', ip_address: 'ip_address') }

    let(:user) { create(:user) }

    context 'when the password is not valid' do
      let(:password) { 'invalid' }

      it 'raises InvalidPasswordError' do
        expect { api_authenticate }.to raise_error(Authentication::InvalidPasswordError)
      end
    end

    context 'when the password is valid' do
      let(:password) { 'password' }

      it 'creates a new session' do
        expect { api_authenticate }.to change(UserSession, :count).by(1)

        expect(UserSession.last).to have_attributes(
          user_agent: 'user_agent',
          ip_address: 'ip_address',
          client_id:  be_present,
          user:       user
        )
      end

      it 'updates the last sign in date of the user' do
        freeze_time

        expect { api_authenticate }.to change(user, :last_sign_in_at).from(nil).to(Time.zone.now)
      end

      it 'returns a new JWT' do
        jwt = api_authenticate

        payload = Authentication::TokenDecoder.parse(jwt)
        expect(payload).to have_attributes(client_id: user.sessions.last.client_id)
      end

      context 'and the user has more sessions than the limit' do
        before { stub_const("#{described_class}::TOKEN_LIMIT", 1) }

        it 'removes the old one' do
          old_session = create(:user_session, user: user)

          expect { api_authenticate }.not_to change(UserSession, :count)

          expect(UserSession).not_to exist(old_session.id)
        end
      end
    end
  end

  describe '#generate_jwt' do
    subject(:jwt) { user.generate_jwt('client_id') }

    let(:user) { build_stubbed(:user) }

    it 'generates a valid JWT' do
      payload = Authentication::TokenDecoder.parse(jwt)

      expect(payload).to have_attributes(client_id: 'client_id')
    end
  end

  describe '#remove_client' do
    subject(:remove_client) { user.remove_client('client_id') }

    let(:user) { create(:user) }

    it 'removes the session' do
      session = create(:user_session, user: user, client_id: 'client_id')

      remove_client

      expect(UserSession).not_to exist(session.id)
    end
  end

  describe '#clients' do
    subject(:clients) { user.clients }

    let(:user) { create(:user, :with_session) }

    it 'returns the client_id of all session' do
      expect(clients).to eq([user.sessions.first.client_id])
    end
  end

  describe '#update_session' do
    subject(:update_session) { user.update_session('client_id') }

    let(:user) { create(:user) }

    it 'updates the last_used time of session' do
      session = create(:user_session, user: user, client_id: 'client_id')

      expect { update_session }.to change { session.reload.last_used }
    end
  end
end
