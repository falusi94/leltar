# frozen_string_literal: true

RSpec::Matchers.define :match_api_response do |entry|
  match do |json|
    entry_hash = if entry.is_a?(Hash)
                   entry
                 else
                   public_send(:"api_#{entry.class.to_s.demodulize.underscore}_hash", entry)
                 end

    expect(json).to include(data: entry_hash)
  end
end
