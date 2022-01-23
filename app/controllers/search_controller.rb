# frozen_string_literal: true

class SearchController < ApplicationController
  before_action :require_admin
  before_action :set_groups

  def index
    return redirect_to search_export_path(search_params) if params[:export_button]

    @q     = Item.ransack(search_params)
    @items = @q.result(distinct: true)
    @items = ItemDecorator.decorate_collection(@items.page(params[:page]))
  end

  def export
    @q = Item.ransack(params)
    @items = @q.result(distinct: true)
    send_data @items.to_csv, filename: "export-#{Date.today}.csv"
  end

  private

  def search_params
    return unless params.key? :q

    params.require(:q)
          .permit(:name_cont, :specific_name_cont, :description_cont, :group_id_eq, :serial_cont,
                  :at_who_cont, :comment_cont, :inventory_number_cont, :condition_eq, :status_eq,
                  :accountancy_state_eq, :location_cont, :organization_eq, :entry_date_lteq,
                  :entry_date_gteq, :purchase_date_lteq, :purchase_date_gteq, :last_check_lteq,
                  :last_check_gteq, :entry_price_lteq, :entry_price_gteq, :warranty_lteq,
                  :warranty_gteq)
  end
end
