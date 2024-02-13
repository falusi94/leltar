# frozen_string_literal: true

describe Authentication::TokenDecoder do
  it 'generates the proper secret' do
    payload = {
      user_id:    'user_id',
      client_id:  'client_id',
      created_at: 'created_at'
    }
    token = JWT.encode(payload, 'secret', 'HS256')

    decoded_token = described_class.parse(token)

    expect(decoded_token).to have_attributes(payload)
  end
end
