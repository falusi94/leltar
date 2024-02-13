# frozen_string_literal: true

describe Authentication::TokenValidator do
  subject(:validate_token) { described_class.execute(jwt: jwt, user_class: User) }

  before { allow(Rails.application.credentials).to receive(:secret_key_base).and_return('secret') }

  context 'when invalid token is provided' do
    let(:jwt) { 'invalid' }

    it 'raises InvalidTokenError error' do
      expect { validate_token }.to raise_error(Authentication::InvalidTokenError)
    end
  end

  context 'when the user does not exist' do
    let(:jwt) { Authentication::TokenGenerator.generate('user_id', 'client_id') }

    it 'raises InvalidUserError error' do
      expect { validate_token }.to raise_error(Authentication::InvalidUserError)
    end
  end

  context 'when the client token persisted' do
    let(:jwt) { Authentication::TokenGenerator.generate(user.id, 'client_id') }
    let(:user) { create(:user) }

    it 'raises InvalidClientError error' do
      expect { validate_token }.to raise_error(Authentication::InvalidClientError)
    end
  end

  context 'when the client token is persisted' do
    let(:jwt)     { Authentication::TokenGenerator.generate(user.id, session.client_id) }
    let(:session) { user.sessions.first }
    let(:user)    { create(:user, :with_session) }

    it 'raises error' do
      freeze_time

      expect(validate_token).to eq(
        [
          jwt,
          user,
          Authentication::Token.new(user.id, session.client_id, Time.now.to_i)
        ]
      )
    end
  end
end
