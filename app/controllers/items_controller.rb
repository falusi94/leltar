class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy, :picture_get, :picture_post, :picture_form]
  before_action :set_groups, only: [:new, :edit, :create, :update]
  before_action :require_group_read, only: [:show]
  before_action :require_group_write, only: [:edit, :update, :destroy, :picture_post]

  def index
    if params[:group_id]
      group = Group.find(params[:group_id])
      @items = group.items.page(params[:page])
    elsif current_user.admin
      @items = Item.all.page(params[:page])
    else
      # This should be optimized
      @items = Item.select { |item| current_user.can_read?(item.group_id) }
                   .page(params[:page])
    end
  end

  def show
    @item = @item.versions[params[:version_idx].to_i].reify if params[:version_idx]
  end

  def new
    return unauthorized_page if @groups.empty?
    @item = Item.new
  end

  def edit
  end

  def create
    @item = Item.new(item_params)
    if @item.validate && current_user.can_write?(@item.group)
      return redirect_to @item, notice: 'Sikeres létrehozás' if @item.save
    end
    render :new
  end

  def update
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
      return unauthorized_page unless current_user.can_write?(@item.group_id)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :description, :purchase_date, :entry_date, :last_check, :status, :old_number, :group, :picture)
    end

    def picture_params
      params.require(:item).permit(:picture)
    end
end
