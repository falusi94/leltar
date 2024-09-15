# frozen_string_literal: true

module Setup
  class UsersController < BaseController
    def new
      @user = User.new
    end

    def create
      @user = User.new(user_params)

      if @user.save
        session[:user_id] = @user.id

        redirect_to new_setup_organization_path
      else
        render :new, status: :unprocesasble_entity
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :name, :password, :password_confirmation).merge(admin: true)
    end
  end
end
