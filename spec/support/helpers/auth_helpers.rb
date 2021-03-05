# frozen_string_literal: true

module AuthHelpers
  def login(user = create(:user), password = 'password')
    post '/session', params: { session: { email: user.email, password: password } }
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :request
end
