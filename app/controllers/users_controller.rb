class UsersController < ApplicationController
  before_action :set_user, except: %i[index new create]
  before_action -> { authorize(User) }, only: %i[index new create]
  before_action -> { authorize(@user) }, except: %i[index new create]

  def index
    @users = User.all.page(params[:page])
  end

  def show; end

  def new
    @user = User.new
  end

  def edit; end

  def create
    @user = User.new(user_params)
    return redirect_to @user, notice: t('success.create') if @user.save

    render :new
  end

  def update
    return redirect_to @user, notice: t('success.edit') if @user.update(user_params)

    render :edit
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: t('success.delete')
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(policy(User).permitted_attributes)
  end
end
