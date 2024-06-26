# frozen_string_literal: true

module Web
  class UsersController < BaseController
    before_action :set_user, except: %i[index new create]
    before_action -> { authorize(User) }, only: %i[index new create]
    before_action -> { authorize(@user) }, except: %i[index new create]

    def index
      @pagy, @users = pagy(User.all)
    end

    def show; end

    def new
      @user = User.new
    end

    def edit; end

    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to @user, notice: t('success.create')
      else
        render :new
      end
    end

    def update
      if @user.update(user_params)
        redirect_to @user, notice: t('success.edit')
      else
        render :edit
      end
    end

    def destroy
      @user.destroy
      redirect_to users_url, notice: t('success.delete')
    end

    private

    def set_user
      @user = UserDecorator.find(params[:id])
    end

    def user_params
      params.require(:user).permit(policy(User).permitted_attributes)
    end
  end
end
