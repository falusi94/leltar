# frozen_string_literal: true

module Web
  class LocationsController < BaseController
    before_action :set_location, only: %i[edit update destroy]
    before_action -> { authorize(Location) }, only: %i[index new create]
    before_action -> { authorize(@location) }, except: %i[index new create]

    def index
      @pagy, @locations = pagy(locations)
      @locations = LocationDecorator.decorate_collection(@locations)
    end

    def new
      @location = Location.new
    end

    def edit; end

    def create
      @location = Location.new(location_params)
      return redirect_to locations_path, notice: t('success.created') if @location.save

      render :new
    end

    def update
      return redirect_to locations_path, notice: t('success.edit') if @location.update(location_params)

      render :edit
    end

    def destroy
      @location.destroy
      redirect_to locations_path, notice: t('success.deleted')
    end

    private

    def locations
      policy_scope(Location)
    end

    def set_location
      @location = Location.find(params[:id])
    end

    def location_params
      params
        .require(:location)
        .permit(policy(Location).permitted_attributes)
        .merge(organization: current_organization)
    end
  end
end
