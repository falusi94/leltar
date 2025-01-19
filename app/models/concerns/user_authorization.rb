# frozen_string_literal: true

module UserAuthorization
  extend ActiveSupport::Concern

  included do
    def authorized_to?(permission, organization_arg = nil, organization: nil)
      admin? || strictly_authorized_to?(permission, organization: organization_arg || organization)
    end

    def strictly_authorized_to?(permission, organization:)
      organization && organization_users.with_access(permission).exists?(organization: organization)
    end
  end
end
