# frozen_string_literal: true

module Web
  class SystemAttributesController < BaseController
    before_action -> { authorize(SystemAttribute) }

    def edit
      set_system_attributes
    end

    def update
      SystemAttribute.update!(params)

      redirect_to edit_system_attributes_path, notice: t('success.edit')
    rescue ActiveRecord::RecordInvalid
      set_system_attributes

      render :edit
    end

    private

    def set_system_attributes
      @system_attributes = SystemAttribute.all
      @system_attributes +=
        (SystemAttribute::ATTRIBUTES - @system_attributes.pluck(:name).map(&:to_sym))
        .map { |name| SystemAttribute.new(name: name) }
    end
  end
end
