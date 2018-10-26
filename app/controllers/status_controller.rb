class StatusController < ApplicationController
  before_action :require_admin

  def index
    @status = Status.new
  end

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
    system_attribute_keys = SystemAttribute.all.map(&:name)
    params.permit(system_attribute_keys)
  end
end
