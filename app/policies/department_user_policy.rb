# frozen_string_literal: true

class DepartmentUserPolicy < ApplicationPolicy
  def create?
    user.admin
  end

  alias update? create?
  alias destroy? create?

  def permitted_attributes
    %i[department_id user_id write]
  end
end
