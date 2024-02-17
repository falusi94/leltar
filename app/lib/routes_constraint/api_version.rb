# frozen_string_literal: true

module RoutesConstraint
  class ApiVersion
    APP_NAME = 'leltar'

    def initialize(version:, default: false)
      @version = version
      @default = default
    end

    def matches?(request)
      @last_request = request
      return default unless version_header?

      accept_header.include?("application/vnd.#{app_name}.api-v#{version}+json")
    end

    private

    def version_header?
      %r{application/vnd.#{app_name}.api-v\d+\+json}.match(accept_header).present?
    end

    def app_name
      APP_NAME
    end

    def accept_header
      last_request.headers[:Accept]
    end

    attr_reader :version, :default, :last_request
  end
end
