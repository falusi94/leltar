# frozen_string_literal: true

module Api
  module V1
    class DepartmentsController < ResourcesController
      private

      def resources
        policy_scope(current_organization.departments)
      end

      def create_resource_params
        super.merge(organization: current_organization)
      end
    end
  end
end
