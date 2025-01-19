# frozen_string_literal: true

module Web
  class DepartmentsController < BaseController
    before_action :set_department, -> { authorize(@department) }, only: %i[edit update destroy]

    def index
      authorize(current_organization, :index_department?)

      set_departments
      @pagy, @departments = pagy(@departments)
      @departments = DepartmentDecorator.decorate_collection(@departments)
    end

    def new
      @department = Department.new(organization: current_organization)
      authorize(@department)
    end

    def edit; end

    def create
      @department = Department.new(department_params)
      authorize(@department)

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
      params
        .require(:department)
        .permit(policy(Department).permitted_attributes)
        .merge(organization: current_organization)
    end
  end
end
