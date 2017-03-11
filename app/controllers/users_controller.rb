class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
    require_admin
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if @user.id != current_user.id
      require_admin
    end
  end

  # GET /users/new
  def new
    require_admin
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    if @user.id != current_user.id
      require_admin
    end
  end

  # POST /users
  # POST /users.json
  def create
    require_admin do
      @user = User.new(user_params)

      respond_to do |format|
        if @user.save
          format.html { redirect_to @user, notice: 'User was successfully created.' }
          format.json { render :show, status: :created, location: @user }
        else
          format.html { render :new }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if @user.id == current_user.id || current_user.admin
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      render status: 401, inline: 'Unauthorized'
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    require_admin do
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      if current_user.admin
        params.require(:user).permit(:name, :email, :password, :password_confirmation, :read_rights, :write_rights, :admin)
      else 
        params.require(:user).permit(:email, :password, :password_confirmation)
      end
    end
end
