# frozen_string_literal: true

module Items
  class StatusChecksController < ApplicationController
    def create
      authorize(item, :update?)

      if item.update(item_params)
        redirect_to item, notice: t('success.edit')
      else
        redirect_to item, alert: t(:error_during_save)
      end
    end

    private

    def item
      @item ||= Item.find(params[:item_id])
    end

    def item_params
      params.require(:item).permit(:condition, :status).merge(last_check: Time.zone.now)
    end
  end
end
