# frozen_string_literal: true

class ItemPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    Pundit.policy(auth_scope, record.department).read_items?
  end

  def edit?
    Pundit.policy(auth_scope, record.department).write_items?
  end
  alias update?  edit?
  alias destroy? edit?
  alias create?  edit?

  def new?
    user.admin || user.write_all_department || user.department_users.any?(&:write)
  end

  def search?
    user.admin
  end

  def permitted_attributes
    %i[name description purchase_date entry_date department_id organization number parent_id specific_name serial
       location at_who warranty comment inventory_number entry_price accountancy_state photo invoice]
  end

  class Scope < Scope
    def resolve
      if user.admin || user.read_all_department
        scope.all
      else
        scope.where(department: user.departments)
      end
    end
  end
end
