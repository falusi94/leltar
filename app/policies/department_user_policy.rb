# frozen_string_literal: true

class DepartmentUserPolicy < ApplicationPolicy
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
end
