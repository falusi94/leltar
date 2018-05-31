class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_admin, except: [:edit, :update]

  def index
    @users = User.all
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
    if @user.id != current_user.id
      require_admin
    end
  end

  def create
    @user = User.new(user_params)
    return redirect_to @user, notice: 'Sikeresen létrehozva' if @user.save
    render :new
  end

  def update
    require_admin if @user.id == current_user.id
    return redirect_to @user, notice: 'Sikeresen módosítva' if @user.update(user_params)
    render :edit
  end

  def destroy
    @user.destroy
    redirect_to users_url, notice: 'Sikeresen törölve'
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      if current_user.admin
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :admin)
      else
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
end
