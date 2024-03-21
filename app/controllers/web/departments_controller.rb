# frozen_string_literal: true

module Web
  class DepartmentsController < BaseController
    before_action :set_department, only: %i[edit update destroy]
    before_action -> { authorize(Department) }, only: %i[index new create]
    before_action -> { authorize(@department) }, except: %i[index new create]

    def index
      set_departments
      @pagy, @departments = pagy(@departments)
      @departments = DepartmentDecorator.decorate_collection(@departments)
    end

    def new
      @department = Department.new
    end

    def edit; end

    def create
      @department = Department.new(department_params)
      return redirect_to department_items_path(@department), notice: t('success.create') if @department.save

      render :new
    end

    def update
      return redirect_to departments_path, notice: t('success.edit') if @department.update(department_params)

      render :edit
    end

    def destroy
      @department.destroy
      redirect_to departments_url, notice: t('success.delete')
    end

    private

    def set_department
      @department = DepartmentDecorator.find(params[:id])
    end

    def department_params
      params.require(:department).permit(policy(Department).permitted_attributes)
    end
  end
end
