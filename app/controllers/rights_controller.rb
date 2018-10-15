class RightsController < ApplicationController
  before_action :require_admin

  def create
    right = Right.new
    right.user = User.find(params[:user][:id])
    right.group = Group.find(params[:group][:id])
    right.write = true if params[:write]
    return redirect_to :back, notice: 'Sikeres hozzáadás' if right.save

    redirect_to :back, alert: 'Hiba hozzáadás közben'
  end

  def update
    right = Right.find(params[:id])
    right.write = !right.write
    return redirect_to :back, notice: 'Sikeres módosítás' if right.save

    redirect_to :back, alert: 'Hiba módosítás során'
  end

  def destroy
    right = Right.find(params[:id])
    right.destroy
    redirect_to :back, notice: 'Sikeres törlés'
  end
end
