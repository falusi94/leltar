# frozen_string_literal: true

class DepartmentUserPolicy < ApplicationPolicy
  def index?
    user.authorized_to?(:index_department_user, organization: organization)
  end

  def create?
    user.authorized_to?(:create_department_user?, organization: record.department&.organization)
  end

  def update?
    user.authorized_to?(:update_department_user?, organization: record.department&.organization)
  end

  def destroy?
    user.authorized_to?(:destroy_department_user?, organization: record.department&.organization)
  end

  def permitted_attributes
    %i[department_id user_id write]
  end

  class Scope < Scope
    def resolve
      department_users = scope.where_assoc_exists(:department, organization_id: organization.id)

      if user.authorized_to?(:index_department_user, organization: organization)
        department_users
      else
        department_users.where(user: user)
      end
    end
  end
end
