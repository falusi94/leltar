# frozen_string_literal: true

RSpec::Matchers.define :match_api_response do |entry|
  match do |json|
    entry_hash = public_send(:"api_#{entry.class.to_s.demodulize.underscore}_hash", entry)

    expect(json).to include(data: entry_hash)
  end
end
