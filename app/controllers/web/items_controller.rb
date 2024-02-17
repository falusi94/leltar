# frozen_string_literal: true

module Web
  class ItemsController < BaseController
    before_action :set_item, except: %i[index new create]
    before_action :set_groups, only: %i[new edit create update]
    before_action -> { authorize(@item) }, only: %i[show edit update destroy]

    def index
      @group = Group.find(params[:group_id]) if params[:group_id]

      @items = ItemDecorator.decorate_collection(items.page)
    end

    def show
      @item = ItemDecorator.decorate(@item)
    end

    def new
      authorize(Item)
      return unauthorized_page if @groups.empty?

      @item = Item.new(group_id: params[:group_id] || @groups.first.id)
    end

    def edit; end

    def create
      @item = Item.new(item_params)

      authorize(@item)

      if @item.save
        redirect_to @item, notice: t('success.create')
      else
        render :new
      end
    end

    def update
      @item.attributes = item_params

      authorize(@item) # Check if the new group is also accessible by the user

      @item.attributes = status_update_params if params[:item][:update]

      if @item.save
        redirect_to @item, notice: t('success.edit')
      else
        render :edit
      end
    end

    def destroy
      @item.destroy
      redirect_to items_url, notice: t('success.delete')
    end

    private

    def set_item
      @item = Item.find(params[:id])
    end

    def items
      ItemsQuery.fetch(params, scope: policy_scope(Item).not_a_child)
    end

    def item_params
      params.require(:item)
            .permit(:name, :description, :purchase_date, :entry_date, :group_id,
                    :organization, :number, :parent_id, :specific_name, :serial,
                    :location, :at_who, :warranty, :comment, :inventory_number,
                    :entry_price, :accountancy_state, :photo, :invoice)
    end

    def status_update_params
      params.require(:item).permit(:status, :condition).merge(last_check: Time.zone.today)
    end
  end
end
