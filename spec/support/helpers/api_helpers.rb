# frozen_string_literal: true

module ApiHelpers
  def api_headers(further_headers = {})
    {
      Accept: 'application/vnd.leltar.api-v1+json',
      **further_headers
    }
  end

  def json
    JSON.parse(body, symbolize_names: true)
  end
end

RSpec.configure do |config|
  config.include ApiHelpers, :api_request

  config.define_derived_metadata(file_path: %r{/spec/requests/api/}) do |metadata|
    metadata[:api_request] = true
  end
end
