# frozen_string_literal: true

class DepartmentPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.authorized_to?(:show_department, organization: record.organization)
  end

  def create?
    Pundit.policy(auth_scope, record.organization).create_department?
  end

  def update?
    user.authorized_to?(:update_department, organization: record.organization)
  end

  def destroy?
    user.authorized_to?(:destroy_department, organization: record.organization)
  end

  def show_item?
    user.authorized_to?(:show_item, organization: record.organization) ||
      user.department_users.exists?(department: record)
  end

  def update_item?
    user.authorized_to?(:update_item, organization: record.organization) ||
      user.write_department_users.exists?(department: record)
  end

  def create_item?
    user.authorized_to?(:create_item, organization: record.organization) ||
      user.write_department_users.exists?(department: record)
  end

  def destroy_item?
    user.authorized_to?(:destroy_item, organization: record.organization) ||
      user.write_department_users.exists?(department: record)
  end

  def permitted_attributes
    %i[name organization_id]
  end

  class Scope < Scope
    def resolve
      if user.authorized_to?(:index_department, organization: organization)
        scope.all
      else
        scope.where_assoc_exists(:department_users, user_id: user.id)
      end
    end
  end
end
