class ItemsController < ApplicationController
  include ItemsHelper
  before_action :set_item, only: [:show, :edit, :update, :destroy, :picture_get, :picture_post, :picture_form]

  # GET /items
  # GET /items.json
  def index
    if params[:group]
      access = 'group:'+params[:group]
      @group = params[:group]
    else
      access = 'all'
    end
    require_read(access) do
      respond_to do |format|
        format.json do
          set_items
        end
        format.csv do
          set_items
          render text: generate_csv(@items)
        end
        format.html { @filter = params[:filter] }
      end
    end
  end

  # GET /items/1
  # GET /items/1.json
  def show
    require_read('group:'+@item.group.name) do
      if params[:version_idx]
        @item = @item.versions[params[:version_idx].to_i].reify
      end
    end
  end

  # GET /items/new
  def new
    require_write('all')
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)
    if @item.validate
      require_write('group:'+@item.group.name) do
        respond_to do |format|
          if @item.save
            format.html { redirect_to @item, notice: 'Item was successfully created.' }
            format.json { render :show, status: :created, location: @item }
          else
            format.html { render :new }
            format.json { render json: @item.errors, status: :unprocessable_entity }
          end
        end
      end
    else 
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    require_write('group:'+@item.group.name) do
      respond_to do |format|
        if @item.update(item_params)
          format.html { redirect_to @item, notice: 'Item was successfully updated.' }
          format.json { render :show, status: :ok, location: @item }
        else
          format.html { render :edit }
          format.json { render json: @item.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    require_write('group:'+@item.group.name) do
      @item.destroy
      respond_to do |format|
        format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  def update_all
    require_write('all') do
      items_in = params.permit(items: [:name, :description, :purchase_date, :entry_date, :last_check, :status, :old_number, :group, :id])
      items_in[:items].each do |item_json|
        item = Item.find_by_id(item_json[:id])
        if item
          item.update(item_json)
        else
          item = Item.new(item_json)
        end
        item.save
      end
    end
  end

  def upload_csv
    require_write('all') do
      if params[:csv_file]
        Item.csv_update(params[:csv_file].read.force_encoding('UTF-8'))
        redirect_to '/items'
      else
        render inline: 'Unprocessable entity', status: :unprocessable_entity
      end
    end
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
    require_write('group:'+@item.group.name) do
      respond_to do |format|
        if @item.update(picture_params)
          format.html { redirect_to edit_item_path(@item) }
          format.json { render :show, status: :ok, location: @item }
        else
          format.html { redirect_to edit_item_path(@item) }
          format.json { render json: @item.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def picture_form
    render layout: false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    def set_items
      if params[:filter]
        @items = Item.filter(params[:filter])
      else
        @items = Item.all
      end
      if params[:group]
        Rails.logger.debug "got params"
        group = Group.by_name(params[:group])
        if group
          Rails.logger.debug "filtering to group #{group.name}"
          @items = @items.where(group_id: group.id)
        else
          @items = []
        end
      end
      @item_count = @items.size
      @items = paginate(@items)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :description, :purchase_date, :entry_date, :last_check, :status, :old_number, :group, :picture)
    end

    def picture_params
      params.require(:item).permit(:picture)
    end

    def paginate(ary)
      if !ary.is_a?(Array)
        ary = ary.to_a
      end
      if params[:page]
        page_index = params[:page].to_i - 1 
        page_size = params[:per_page].to_i
        ary.slice(page_index*page_size, page_size)
      else
        ary
      end
    end
end
