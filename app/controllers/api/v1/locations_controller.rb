# frozen_string_literal: true

module Api
  module V1
    class LocationsController < ResourcesController
      private

      def create_resource_params
        super.merge(organization: current_organization)
      end
    end
  end
end
