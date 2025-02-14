# frozen_string_literal: true

module Api
  module V1
    class DepartmentUsersController < ResourcesController
      private

      def resources
        policy_scope(current_organization.department_users)
      end
    end
  end
end
