class ItemsController < ApplicationController
  before_action :set_item, except: %i[index new create]
  before_action :set_groups, only: %i[new edit create update]
  before_action :set_possible_parents, only: %i[new edit create update]
  before_action -> { authorize(@item) }, only: %i[show edit update destroy]

  def index
    if params[:query]
      query = params[:query]
      match = query.include?('!') ? :word : :word_middle
      query = query.tr('!', '')
    else
      query = '*'
    end
    @search_path = request.path
    items_for_group = params[:group_id]
    items_for_group ||= current_user.read_groups.ids
    @group = Group.find(params[:group_id]) if params[:group_id]
    @items = Item.search(query, match: match, page: params[:page], per_page: 25, order: :name,
                                where: { group_id: items_for_group })
    @items = ItemDecorator.decorate_collection(@items)
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
    ip[:last_check] = DateTime.now if params[:update]
    ip[:status] = params[:status] if params[:update]
    ip[:condition] = params[:condition] if params[:update]
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
