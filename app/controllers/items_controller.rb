class ItemsController < ApplicationController
  before_action :set_item, except: [:index, :new, :create]
  before_action :set_groups, only: [:new, :edit, :create, :update]
  before_action :require_group_read, only: [:show]
  before_action :require_group_write, only: [:edit, :update, :destroy, :picture_post]

  def index
    query = params[:query]
    query ||= '*'
    @search_path = request.path
    if params[:group_id]
      @group = Group.find(params[:group_id])
      @items = Item.search(query, page: params[:page], per_page: 25,
                           order: :name, where: {group_id: params[:group_id]})
    elsif current_user.admin
      @items = Item.search(query, page: params[:page], per_page: 25, order: :name)
    else
      @items = Item.search(query, page: params[:page], per_page: 25, order: :name,
                           where: {group_id: current_user.groups.ids})
    end
    @items = ItemDecorator.decorate_collection(@items)
  end

  def show
    @item = @item.versions[params[:version_idx].to_i].reify if params[:version_idx]
    @item = ItemDecorator.decorate(@item)
  end

  def new
    return unauthorized_page if @groups.empty?
    @item = Item.new
    if params[:group_id]
      @item.group = Group.find(params[:group_id])
    else
      @item.group = @groups[0]
    end
  end

  def edit
  end

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
    return redirect_to @item, notice: 'Sikeres módosítás' if @item.update(item_params)
    render :edit
  end

  def destroy
    @item.destroy
    redirect_to items_url, notice: 'Sikeres törlés'
  end

  def picture_get
    ix = params[:photo_no]
    if ix
      ix = ix.to_i
    else
      ix = 0
    end
    if @item.photos.size > ix
      redirect_to @item.photos[ix].url
    else
      render inline: 'Nincs ilyen kep', status: 404
    end
  end

  def picture_post
    return redirect_to edit_item_path(@item) if @item.update(picture_params)
    redirect_to edit_item_path(@item)
  end

  def picture_form
    render layout: false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    def require_group_write
      return unauthorized_page unless current_user.can_write?(@item.group_id)
    end

    def require_group_read
      return unauthorized_page unless current_user.can_read?(@item.group_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :description, :purchase_date, :entry_date, :last_check, :status, :old_number, :group_id, :picture)
    end

    def picture_params
      params.require(:item).permit(:picture)
    end
end
