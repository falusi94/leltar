# frozen_string_literal: true

module Authorization
  module ControllerMixin
    extend ActiveSupport::Concern

    included do
      def pundit_user
        Authorization::Scope.new(user: current_user, organization: current_organization)
      end
    end
  end
end
