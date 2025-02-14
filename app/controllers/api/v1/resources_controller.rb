# frozen_string_literal: true

module Api
  module V1
    class ResourcesController < BaseController
      before_action :find_resource, only: %i[show update destroy]
      before_action :authorize_resource, only: %i[show destroy]

      def index
        authorize resource_class

        @pagy, @resources = pagy(resources)
      end

      def show
        render view_base(:show)
      end

      def create
        @resource = resource_class.new(create_resource_params)

        authorize_resource

        if @resource.save
          render view_base(:show), status: :created
        else
          render_error
        end
      end

      def update
        @resource.attributes = update_resource_params

        authorize_resource

        if @resource.save
          render view_base(:show), status: :ok
        else
          render_error
        end
      end

      def destroy
        @resource.destroy
      end

      private

      def resource_class
        resource_name.constantize
      end

      def resource_name
        self.class.to_s.demodulize.gsub('Controller', '').singularize
      end

      def resources
        policy_scope(resource_class)
      end

      def find_resource
        @resource = resource_class.find(params[:id])
      end

      def authorize_resource
        authorize @resource
      end

      def create_resource_params
        params.permit(policy(resource_class).permitted_attributes)
      end

      def update_resource_params
        params.permit(policy(resource_class).permitted_attributes)
      end

      def view_base(rest)
        "api/v1/#{resource_name.tableize}/#{rest}"
      end

      def render_error
        render 'api/v1/errors', status: :unprocessable_entity, locals: { errors: @resource.errors }
      end
    end
  end
end
