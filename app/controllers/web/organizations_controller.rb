# frozen_string_literal: true

module Web
  class OrganizationsController < BaseController
    before_action :set_organization, only: %i[edit update destroy]
    before_action -> { authorize(Organization) }, only: %i[index new create]
    before_action -> { authorize(@organization) }, except: %i[index new create]

    def index
      @pagy, @organizations = pagy(Organization.all)
      @organizations = OrganizationDecorator.decorate_collection(@organizations)
    end

    def new
      @organization = Organization.new
    end

    def edit; end

    def create
      @organization = Organization.new(organization_params)
      return redirect_to organizations_path, notice: t('success.created') if @organization.save

      render :new
    end

    def update
      return redirect_to organizations_path, notice: t('success.edit') if @organization.update(organization_params)

      render :edit
    end

    def destroy
      @organization.destroy
      redirect_to organizations_path, notice: t('success.deleted')
    end

    private

    def set_organization
      @organization = Organization.find(params[:id])
    end

    def organization_params
      params.require(:organization).permit(policy(Organization).permitted_attributes)
    end
  end
end
