# frozen_string_literal: true

class TestPage
  include Rails.application.routes.url_helpers
  include RSpec::Mocks::ExampleMethods
  include Capybara::DSL

  def self.visit
    new.tap { |new_page| new_page.visit self::URL }
  end
end
