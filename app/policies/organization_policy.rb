# frozen_string_literal: true

class OrganizationPolicy < ApplicationPolicy
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

  def permitted_attributes
    %i[name slug currency_code fiscal_period_starts_at fiscal_period_unit]
  end
end
