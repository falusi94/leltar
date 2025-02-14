# frozen_string_literal: true

module RoutesConstraint
  class AdminUser
    def self.matches?(request)
      user = User.find_by(id: request.session[:user_id])

      user&.admin? || false
    end
  end
end
