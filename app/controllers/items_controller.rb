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

  def picture_get
    redirect_to @item.picture.url
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

  def group_index
    if current_user.can_read?('all')
      @groups = Item.groups 
    else
      @groups = current_user.read_groups 
    end
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
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :description, :purchase_date, :entry_date, :last_check, :status, :old_number, :group, :picture)
    end

    def picture_params
      params.require(:item).permit(:picture)
    end
end
