class ItemsController < ApplicationController
  before_action :set_item, except: %i[index new create]
  before_action :set_groups, only: %i[new edit create update]
  before_action :set_possible_parents, only: %i[new edit create update]
  before_action -> { authorize(@item) }, only: %i[show edit update destroy]

  def index
    @search_path = request.path
    @group       = Group.find(params[:group_id]) if params[:group_id]

    @items       = ItemDecorator.decorate_collection(items.page)
  end

  def show
    @item = ItemDecorator.decorate(@item)
  end

  def new
    return unauthorized_page if @groups.empty?

    @item = Item.new
    @item.group = params[:group_id] ? Group.find(params[:group_id]) : @groups[0]
  end

  def edit; end

  def create
    @item = Item.new(item_params)
    unless current_user.can_write?(item_params[:group_id].to_i)
      return redirect_back fallback_location: root_path, alert: t(:no_permission)
    end

    return redirect_to @item, notice: t('success.create') if @item.save

    render :new
  end

  def update
    unless current_user.can_write?(item_params[:group_id].to_i)
      return redirect_back fallback_location: root_path, alert: t(:no_permission)
    end

    ip = item_params
    if params[:item][:update]
      ip[:last_check] = DateTime.now
      ip[:status]     = params[:item][:status]
      ip[:condition]  = params[:item][:condition]
    end
    return redirect_to @item, notice: t('success.edit') if @item.update(ip)

    render :edit
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
    fields = %i[name description status serial specific_name location at_who condition inventory_number]

    scope = policy_scope(Item)
    scope = scope.where(group_id: params[:group_id]) if params[:group_id]
    scope = scope.includes(:group).search(params[:query], fields: fields, count: -1) if params[:query]
    scope
  end

  def set_possible_parents
    possible_parents = @item.group.items.reject(&:child?) if @item&.group
    possible_parents ||= Item.all.reject(&:child?)
    @possible_parents = ItemDecorator.decorate_collection(possible_parents)
  end

  def item_params
    params.require(:item)
          .permit(:name, :description, :purchase_date, :entry_date, :group_id,
                  :organization, :number, :parent_id, :specific_name, :serial,
                  :location, :at_who, :warranty, :comment, :inventory_number,
                  :entry_price, :accountancy_state, :photo, :invoice)
  end
end
