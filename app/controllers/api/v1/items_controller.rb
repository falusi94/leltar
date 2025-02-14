# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ResourcesController
      private

      def resources
        ItemsQuery.fetch(params, scope: policy_scope(Item).not_a_child)
      end

      def create_resource_params
        update_resource_params.except(:department_id).merge(department: department)
      end

      def department
        Department.find(params[:department_id])
      end
    end
  end
end
