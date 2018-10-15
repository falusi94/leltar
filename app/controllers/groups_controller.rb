class GroupsController < ApplicationController
  before_action :set_group, only: %i[show edit update destroy]
  before_action :require_admin, except: [:index]

  def index
    set_groups
    @groups = Kaminari.paginate_array(@groups).page(params[:page])
    @groups = GroupDecorator.decorate_collection(@groups)
  end

  def show; end

  def new
    @group = Group.new
  end

  def edit; end

  def create
    @group = Group.new(group_params)
    return redirect_to group_items_path(@group), notice: 'Sikeresen létrehozva' if @group.save

    render :new
  end

  def update
    return redirect_to groups_path, notice: 'Sikeresen módosítva' if @group.update(group_params)

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
