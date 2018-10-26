class PhotosController < ApplicationController
  before_action :require_group_write

  def create
    item = Item.find(params[:item_id])
    item.photos.attach(params[:photo])
    redirect_to edit_item_path(item)
  end

  def destroy
    item = Item.find(params[:item_id])
    item.photos.find_by_id(params[:id].to_i).purge
    redirect_to edit_item_path(item)
  end
end
