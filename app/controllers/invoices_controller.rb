class InvoicesController < ApplicationController
  before_action :require_group_write

  def create
    item = Item.find(params[:item_id])
    item.invoice.attach(params[:photo])
    redirect_to edit_item_path(item)
  end

  def destroy
    item = Item.find(params[:item_id])
    item.invoice.purge
    redirect_to edit_item_path(item)
  end
end
