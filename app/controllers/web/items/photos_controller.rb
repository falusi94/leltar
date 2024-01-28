# frozen_string_literal: true

module Web
  module Items
    class PhotosController < BaseController
      before_action -> { authorize(item, :edit?) }

      def create
        item.photos.attach(params[:photo])

        redirect_to edit_item_path(item)
      end

      def destroy
        item.photos.find_by(id: params[:id].to_i).purge

        redirect_to edit_item_path(item)
      end

      private

      def item
        @item ||= Item.find(params[:item_id])
      end
    end
  end
end
