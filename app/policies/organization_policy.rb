# frozen_string_literal: true

class OrganizationPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    user.authorized_to?(:show_organization, organization: record)
  end

  def create?
    user.admin
  end

  def update?
    user.authorized_to?(:update_organization, organization: record)
  end

  def destroy?
    user.authorized_to?(:destroy_organization, organization: record)
  end

  def show_depreciation_config?
    user.authorized_to?(:show_depreciation_config, organization: record)
  end

  def update_depreciation_config?
    user.authorized_to?(:update_depreciation_config, organization: record)
  end

  def create_department?
    user.authorized_to?(:create_department, organization: record)
  end

  def index_department?
    user.authorized_to?(:show_department, organization: record)
  end

  def create_item?
    user.authorized_to?(:create_item, organization: record) ||
      user.departments.with_write_access.exists?(organization: record)
  end

  def search_item?
    user.authorized_to?(:search_item, organization: record)
  end

  def show_status?
    user.authorized_to?(:show_status, organization: record)
  end

  def index_location?
    user.authorized_to?(:index_location, organization: record)
  end

  def create_location?
    user.authorized_to?(:create_location, organization: record)
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
