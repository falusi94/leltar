# frozen_string_literal: true

class SystemAttributesController < ApplicationController
  before_action -> { authorize(SystemAttribute) }

  def edit
    set_system_attributes
  end

  def update
    ActiveRecord::Base.transaction do
      system_params.each do |key, param|
        SystemAttribute.find_by(name: key).update!(value: param)
      end
    end

    redirect_to status_index_path
  rescue ActiveRecord::RecordInvalid
    set_system_attributes

    render :edit
  end

  private

  def set_system_attributes
    @system_attributes = SystemAttribute.all
  end

  def system_params
    system_attribute_keys = SystemAttribute.pluck(:name)

    params.permit(system_attribute_keys)
  end
end
