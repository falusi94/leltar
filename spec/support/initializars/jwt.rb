# frozen_string_literal: true

RSpec.configure do |config|
  config.before { allow(Rails.application.credentials).to receive(:secret_key_base).and_return('secret') }
end
