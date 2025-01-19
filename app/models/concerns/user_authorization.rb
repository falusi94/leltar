# frozen_string_literal: true

module UserAuthorization
  extend ActiveSupport::Concern

  included do
    def authorized_to?(permission, organization:)
      admin? || strictly_authorized_to?(permission, organization: organization)
    end

    def strictly_authorized_to?(permission, organization:)
      organization && organization_users.with_access(permission).exists?(organization: organization)
    end
  end
end
