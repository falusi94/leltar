# frozen_string_literal: true

module Api
  module V1
    class ItemsController < ResourcesController
      private

      def resources
        ItemsQuery.fetch(params, scope: super.not_a_child)
      end

      def create_resource_params
        update_resource_params.except(:group_id).merge(group: group)
      end

      def group
        Group.find(params[:group_id])
      end
    end
  end
end
