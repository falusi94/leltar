# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
  if Rails.configuration.x.routes.cors_allowed_origins.any?
    allow do
      origins Rails.configuration.x.routes.cors_allowed_origins
      resource '*', headers: :any, methods: %i[get post patch put delete], expose: ['Authorization']
    end
  end
end
