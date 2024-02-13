# frozen_string_literal: true

describe Authentication::TokenGenerator do
  subject(:token) { described_class.generate('user_id', 'client_id') }

  let(:payload) { JWT.decode(token, 'secret', true, algorithm: 'HS256') }

  it 'generates the proper secret' do
    expect(payload.first).to include(
      'user_id'    => 'user_id',
      'client_id'  => 'client_id',
      'created_at' => be_present
    )
  end

  context 'when the token is expired' do
    it 'raises JWT::ExpiredSignature' do
      token

      travel_to 5.hours.from_now do
        expect { payload }.to raise_error(JWT::ExpiredSignature)
      end
    end
  end
end
