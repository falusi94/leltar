class SearchController < ApplicationController
  before_action :require_admin

  def index
    @q = Item.ransack(search_params)
    @items = @q.result(distinct: true)
    @items = ItemDecorator.decorate_collection(@items.page(params[:page]))
  end

  private

  def search_params
    params.require(:q)
          .permit(:name_cont, :specific_name_cont, :description_cont, :group_id, :serial_cont,
                  :at_who_cont, :comment_cont, :inventory_number_cont, :condition, :status,
                  :accountancy_state, :location_cont, :organization, :entry_date_lteq,
                  :entry_date_gteq, :purchase_date_lteq, :purchase_date_gteq, :last_check_lteq,
                  :last_check_gteq, :entry_price_lteq, :entry_price_gteq, :warranty_lteq,
                  :warranty_gteq)
  end
end
