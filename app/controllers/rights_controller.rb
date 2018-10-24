class RightsController < ApplicationController
  before_action :require_admin

  def create
    right = Right.new
    right.user = User.find(params[:user][:id])
    right.group = Group.find(params[:group][:id])
    right.write = true if params[:write]
    return redirect_to :back, notice: t('success.create') if right.save

    redirect_to :back, alert: t(:error_during_save)
  end

  def update
    right = Right.find(params[:id])
    right.write = !right.write
    return redirect_to :back, notice: t('success.edit') if right.save

    redirect_to :back, alert: t(:error_during_save)
  end

  def destroy
    right = Right.find(params[:id])
    right.destroy
    redirect_to :back, notice: t('success.delete')
  end
end
