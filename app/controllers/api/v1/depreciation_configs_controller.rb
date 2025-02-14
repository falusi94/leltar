# frozen_string_literal: true

module Api
  module V1
    class DepreciationConfigsController < ResourcesController
      private

      def find_resource
        @resource = current_organization.safe_depreciation_config
      end
    end
  end
end
