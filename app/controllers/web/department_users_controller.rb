# frozen_string_literal: true

module Web
  class DepartmentUsersController < BaseController
    before_action -> { authorize(DepartmentUser) }

    def create
      department_user = DepartmentUser.new(department_user_params)

      if department_user.save
        redirect_back fallback_location: root_path, notice: t('success.create')
      else
        redirect_back fallback_location: root_path, alert: t(:error_during_save)
      end
    end

    def update
      department_user.write = !department_user.write

      if department_user.save
        redirect_back fallback_location: root_path, notice: t('success.edit')
      else
        redirect_back fallback_location: root_path, alert: t(:error_during_save)
      end
    end

    def destroy
      department_user.destroy

      redirect_back fallback_location: root_path, notice: t('success.delete')
    end

    private

    def department_user
      @department_user ||= DepartmentUser.find(params[:id])
    end

    def department_user_params
      params.require(:department_user).permit(policy(DepartmentUser).permitted_attributes)
    end
  end
end
