class ItemsController < ApplicationController
  before_action :set_item, except: %i[index new create]
  before_action :set_groups, only: %i[new edit create update]
  before_action :require_group_read, only: [:show]
  before_action :require_group_write, only: %i[edit update destroy picture_post
                                               update_last_check]

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
    @items = Item.search(query, match: match, page: params[:page],
                                per_page: 25, order: :name,
                                where: { group_id: items_for_group })
    @items = ItemDecorator.decorate_collection(@items)
  end

  def show
    @item = @item.versions[params[:version_idx].to_i].reify if params[:version_idx]
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
      return redirect_to :back, alert: 'Nincs jogosultságod!'
    end

    return redirect_to @item, notice: 'Sikeres létrehozás' if @item.save

    render :new
  end

  def update
    unless current_user.can_write?(item_params[:group_id].to_i)
      return redirect_to :back, alert: 'Nincs jogosultságod!'
    end

    ip = item_params
    ip[:last_check] = DateTime.now if params[:update]
    ip[:status] = params[:status] if params[:update]
    ip[:condition] = params[:condition] if params[:update]
    return redirect_to @item, notice: 'Sikeres módosítás' if @item.update(ip)

    render :edit
  end

  def update_last_check
    @item.last_check = DateTime.now
    @item.status = params[:status]
    @item.condition = params[:condition]
    return redirect_to @item, notice: 'Sikeres módosítás' if @item.save

    redirect_to @item, alert: 'Hiba mentés közben'
  end

  def destroy
    @item.destroy
    redirect_to items_url, notice: 'Sikeres törlés'
  end

  def picture_get
    ix = params[:photo_no]
    ix = ix ? ix.to_i : 0
    return redirect_to @item.photos[ix].url if @item.photos.size > ix

    render inline: 'Nincs ilyen kep', status: 404
  end

  def picture_post
    return redirect_to edit_item_path(@item) if @item.update(picture_params)

    redirect_to edit_item_path(@item)
  end

  def picture_form
    render layout: false
  end

  private

  def set_item
    @item = Item.find(params[:id])
  end

  def require_group_write
    return unauthorized_page unless current_user.can_write?(@item.group_id)
  end

  def require_group_read
    return unauthorized_page unless current_user.can_read?(@item.group_id)
  end

  def item_params
    params.require(:item)
          .permit(:name, :description, :purchase_date, :entry_date, :group_id,
                  :organization, :number, :parent, :specific_name, :serial,
                  :location, :at_who, :warranty, :comment, :inventory_number,
                  :entry_price, :accountancy_state)
  end

  def picture_params
    params.require(:item).permit(:picture)
  end
end
