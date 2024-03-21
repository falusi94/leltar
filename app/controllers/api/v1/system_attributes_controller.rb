# frozen_string_literal: true

module Api
  module V1
    class SystemAttributesController < ResourcesController
      skip_before_action :find_resource

      def update
        authorize SystemAttribute

        ActiveRecord::Base.transaction do
          system_params.each do |key, param|
            SystemAttribute.find_by(name: key).update!(value: param)
          end
        end

        head :ok
      end

      private

      def system_params
        system_attribute_keys = SystemAttribute.pluck(:name)

        params.permit(system_attribute_keys)
      end
    end
  end
end
