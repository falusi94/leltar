# frozen_string_literal: true

module Api
  module V1
    module Items
      class InvoicesController < BaseController
        def show
          authorize item, :show?

          @resource = item.invoice
          return head(:not_found) if @resource.blank?

          render 'api/v1/attachments/show'
        end

        def create
          authorize item, :update?

          item.invoice.attach(params[:photo])
        end

        def destroy
          authorize item, :update?

          return head(:not_found) if item.invoice.blank?

          item.invoice.purge
        end

        private

        def item
          @item ||= policy_scope(Item).find(params[:item_id])
        end
      end
    end
  end
end
