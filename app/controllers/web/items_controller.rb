# frozen_string_literal: true

module Web
  class ItemsController < BaseController
    before_action :set_item, except: %i[index new create]
    before_action :set_departments, only: %i[new edit create update]
    before_action -> { authorize(@item) }, only: %i[show edit update destroy]

    def index
      authorize(Item)

      @department = Department.find(params[:department_id]) if params[:department_id]

      @pagy, @items = pagy(items)
      @items = ItemDecorator.decorate_collection(@items)
    end

    def show
      @item = ItemDecorator.decorate(@item)
    end

    def new
      authorize(Item)
      return unauthorized_page if @departments.empty?

      @item = Item.new(department_id: params[:department_id])
    end

    def edit; end

    def create
      @item = Item.new(item_params.merge(status_update_params))

      authorize(@item)

      if @item.save
        redirect_to @item, notice: t('success.create')
      else
        render :new
      end
    end

    def update
      @item.attributes = item_params

      authorize(@item) # Check if the new department is also accessible by the user

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
      ItemsQuery
        .fetch(params, scope: policy_scope(current_organization.items).not_a_child)
        .includes(:department, :children)
    end

    def item_params
      params.require(:item).permit(policy(Item).permitted_attributes).merge(organization: current_organization)
    end

    def status_update_params
      params.require(:item).permit(:status, :condition).merge(last_check: Time.zone.today)
    end
  end
end
