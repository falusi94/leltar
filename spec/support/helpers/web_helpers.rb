# frozen_string_literal: true

module WebHelpers
  def login(user = create(:user), password = 'password')
    post '/session', params: { session: { email: user.email, password: password } }
  end

  def login_admin
    user = create(:admin)
    login(user)
  end
end

RSpec.configure do |config|
  config.include WebHelpers, :web_request

  config.define_derived_metadata(file_path: %r{/spec/requests/web/}) do |metadata|
    metadata[:web_request] = true
  end
end
