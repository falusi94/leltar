# frozen_string_literal: true

module Web
  class SearchController < BaseController
    before_action -> { authorize(current_organization, :search_item?) }
    before_action :set_departments

    def index
      @q    = current_organization.items.ransack(search_params)
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
            .permit(:name_cont, :description_cont, :department_id_eq, :serial_number_cont, :inventory_number_cont,
                    :condition_eq, :status_eq, :accountancy_state_eq, :location_name_cont, :entry_date_lteq,
                    :entry_date_gteq, :acquisition_date_lteq, :acquisition_date_gteq, :last_check_lteq,
                    :last_check_gteq, :entry_price_lteq, :entry_price_gteq, :warranty_end_at_lteq,
                    :warranty_end_at_gteq)
    end
  end
end
