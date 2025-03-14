require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Leltar
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.active_record.yaml_column_permitted_classes ||= []
    config.active_record.yaml_column_permitted_classes  += [Date, ActiveSupport::TimeWithZone, Time, ActiveSupport::TimeZone]

    config.x.roles = config_for(:roles)
    config.x.routes = config_for(:routes)

    config.generators do |g|
      g.test_framework :rspec
      g.factory_bot dir: 'spec/factories'
    end
  end
end
