# frozen_string_literal: true

module Api
  module V1
    module Items
      class PhotosController < BaseController
        def index
          authorize item, :show?

          @pagy, @resources = pagy(item.photos)

          render 'api/v1/attachments/index'
        end

        def create
          authorize item, :update?

          item.photos.attach(params[:photo])
        end

        def destroy
          authorize item, :update?

          item.photos.find(params[:id]).purge
        end

        private

        def item
          @item ||= Item.find(params[:item_id])
        end
      end
    end
  end
end
