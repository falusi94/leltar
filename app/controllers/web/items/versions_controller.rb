# frozen_string_literal: true

module Web
  module Items
    class VersionsController < BaseController
      before_action -> { authorize(item) }

      def show
        @item = item.versions[version_id].reify
        return not_found_page if @item.blank?

        @item = ItemDecorator.decorate(@item)

        render 'web/items/show'
      end

      private

      def version_id
        params[:id].to_i
      end

      def item
        Item.find(params[:item_id])
      end
    end
  end
end
