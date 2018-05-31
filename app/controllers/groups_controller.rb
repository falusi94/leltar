class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, except: [:index]

  def index
    set_groups
    @groups = @groups.page(params[:page])
  end

  def show
  end

  def new
    @group = Group.new
  end

  def edit
  end

  def create
    @group = Group.new(group_params)
    return redirect_to @group, notice: 'Sikeresen létrehozva' if @group.save

    render :new
  end

  def update
    if @group.update(group_params)
      return redirect_to @group, notice: 'Sikeresen módosítva'
    end
      render :edit
  end

  def destroy
    @group.destroy
    redirect_to groups_url, notice: 'Sikeres törlés'
  end

  private
    def set_group
      @group = Group.find(params[:id])
    end

    def group_params
      params.require(:group).permit(:name)
    end
end
