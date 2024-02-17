# frozen_string_literal: true

module ApiHelpers
  def api_headers(further_headers = {})
    {
      Accept: 'application/vnd.leltar.api-v1+json',
      **further_headers
    }
  end

  def auth_headers(user)
    jwt = user.generate_jwt(user.sessions.first.try(:client_id))

    api_headers('access-token': jwt)
  end

  def json
    JSON.parse(body, symbolize_names: true)
  end

  def api_user_hash(user)
    { email: user.email, name: user.name }
  end
end

RSpec.configure do |config|
  config.include ApiHelpers, :api_request

  config.define_derived_metadata(file_path: %r{/spec/requests/api/}) do |metadata|
    metadata[:api_request] = true
  end
end
