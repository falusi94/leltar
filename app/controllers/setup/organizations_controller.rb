# frozen_string_literal: true

module Setup
  class OrganizationsController < BaseController
    def new
      @organization = Organization.new
    end

    def create
      @organization = Organization.new(organization_params)

      if @organization.save
        redirect_to root_path
      else
        render :new, status: :unprocesasble_entity
      end
    end

    private

    def organization_params
      params.require(:organization).permit(:name, :slug, :currency_code, :fiscal_period_starts_at, :fiscal_period_unit)
    end
  end
end
