class PhotosController < ApplicationController
  def create
    item = Item.find(params[:item_id])
    Photo.create(item: item, file: params[:file])
    redirect_to item
  end

  def destroy
    photo = Photo.find(params[:id])
    photo.destroy
  end
end
