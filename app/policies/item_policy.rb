# frozen_string_literal: true

class ItemPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    Pundit.policy(auth_scope, record.department).show_item?
  end

  def new?
    Pundit.policy(auth_scope, organization).create_item? ||
      user.departments.with_write_access.exists?(organization: organization)
  end

  def create?
    Pundit.policy(auth_scope, record.department).create_item?
  end

  def edit?
    Pundit.policy(auth_scope, record.department).update_item?
  end
  alias update? edit?

  def destroy?
    Pundit.policy(auth_scope, record.department).destroy_item?
  end

  def permitted_attributes
    %i[name description acquisition_date entry_date department_id number parent_id serial_number location_id
       warranty_end_at inventory_number entry_price accountancy_state photo invoice]
  end

  class Scope < Scope
    def resolve
      if user.authorized_to?(:index_department, organization: organization)
        scope.all
      else
        scope.where(department: user.departments)
      end
    end
  end
end
