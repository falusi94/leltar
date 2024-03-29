# frozen_string_literal: true

module Items
  class InvoicesController < ApplicationController
    before_action -> { authorize(item, :edit?) }

    def create
      item.invoice.attach(params[:photo])

      redirect_to edit_item_path(item)
    end

    def destroy
      item.invoice.purge

      redirect_to edit_item_path(item)
    end

    private

    def item
      @item ||= Item.find(params[:item_id])
    end
  end
end
