# frozen_string_literal: true

module Items
  class VersionsController < ApplicationController
    before_action -> { authorize(item) }

    def show
      @item = item.versions[version_id].reify
      return not_found_page if @item.blank?

      @item = ItemDecorator.decorate(@item)

      render 'items/show'
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
