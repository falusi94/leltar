# frozen_string_literal: true

module Web
  class DepreciationConfigsController < BaseController
    before_action :set_depreciation_config
    before_action -> { authorize(@depreciation_config) }

    def show; end

    def edit; end

    def update
      if @depreciation_config.update(depreciation_config_params)
        redirect_to depreciation_config_path, notice: t('success.edit')
      else
        render :edit
      end
    end

    private

    def set_depreciation_config
      @depreciation_config = current_organization.safe_depreciation_config
    end

    def depreciation_config_params
      params.require(:depreciation_config).permit(policy(DepreciationConfig).permitted_attributes)
    end
  end
end
