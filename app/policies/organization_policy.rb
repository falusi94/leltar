# frozen_string_literal: true

class OrganizationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.admin ||
      user.organization_users.with_access(:show_organization).exists?(organization: record)
  end

  def create?
    user.admin
  end

  def update?
    user.admin ||
      user.organization_users.with_access(:update_organization).exists?(organization: record)
  end

  def destroy?
    user.admin ||
      user.organization_users.with_access(:destroy_organization).exists?(organization: record)
  end

  def permitted_attributes
    %i[name slug currency_code fiscal_period_starts_at fiscal_period_unit]
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where_assoc_exists(:organization_users, user_id: user.id)
      end
    end
  end
end
