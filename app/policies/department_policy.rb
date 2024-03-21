# frozen_string_literal: true

class DepartmentPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.admin
  end

  def create?
    user.admin
  end

  def update?
    user.admin
  end

  def destroy?
    user.admin
  end

  def read_items?
    user.admin || user.read_all_department || user.department_users.exists?(department: record)
  end

  def write_items?
    user.admin || user.write_all_department || user.department_users.write.exists?(department: record)
  end

  def permitted_attributes
    %i[name]
  end
end
