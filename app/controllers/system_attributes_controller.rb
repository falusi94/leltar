# frozen_string_literal: true

class SystemAttributesController < ApplicationController
  before_action :require_admin

  def edit
    @system_attributes = SystemAttribute.all
  end

  def update
    success = true
    system_params.each do |key, param|
      success = false unless SystemAttribute.update(name: key, value: param)
    end

    redirect_to status_index_path if success
  end

  private

  def system_params
    system_attribute_keys = SystemAttribute.pluck(:name)

    params.permit(system_attribute_keys)
  end
end
