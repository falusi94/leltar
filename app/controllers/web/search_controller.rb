# frozen_string_literal: true

module Web
  class SearchController < BaseController
    before_action -> { authorize(Item, :search?) }
    before_action :set_departments

    def index
      @q    = Item.ransack(search_params)
      items = @q.result(distinct: true)

      if params[:export_button]
        send_data items.to_csv, filename: "export-#{Time.zone.today}.csv"
      else
        @pagy, items = pagy(items)
        @items = ItemDecorator.decorate_collection(items)
      end
    end

    private

    def search_params
      return unless params.key? :q

      params.require(:q)
            .permit(:name_cont, :specific_name_cont, :description_cont, :department_id_eq, :serial_cont,
                    :at_who_cont, :comment_cont, :inventory_number_cont, :condition_eq, :status_eq,
                    :accountancy_state_eq, :location_cont, :organization_eq, :entry_date_lteq,
                    :entry_date_gteq, :purchase_date_lteq, :purchase_date_gteq, :last_check_lteq,
                    :last_check_gteq, :entry_price_lteq, :entry_price_gteq, :warranty_lteq,
                    :warranty_gteq)
    end
  end
end
