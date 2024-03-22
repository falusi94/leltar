# frozen_string_literal: true

module Api
  module V1
    class SystemAttributesController < ResourcesController
      skip_before_action :find_resource

      def update
        authorize SystemAttribute

        SystemAttribute.update!(params)

        head :ok
      end
    end
  end
end
