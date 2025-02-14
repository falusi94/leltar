# frozen_string_literal: true

class RedirectUrl
  include Rails.application.routes.url_helpers

  def initialize(user)
    @user = user
  end

  def self.generate(...)
    new(...).generate
  end

  def generate
    return new_setup_user_path if no_organization?

    if admin? || many_departments?
      items_path(organization_slug: organization.slug)
    elsif one_department?
      department_items_path(organization_slug: organization.slug, department_id: first_department.id)
    end
  end

  private

  def no_organization?
    Organization.none?
  end

  def many_departments?
    organization.present? && user_departments.second.present?
  end

  def one_department?
    organization.present? && first_department.present?
  end

  def first_department
    user_departments.first
  end

  def organization
    user.last_organization || user_organizations.first
  end

  def user_organizations
    OrganizationPolicy::Scope.new(Authorization::Scope.new(user: user), Organization).resolve
  end

  def user_departments
    DepartmentPolicy::Scope.new(auth_scope, organization.departments).resolve
  end

  def auth_scope
    Authorization::Scope.new(user: user, organization: organization)
  end

  delegate :admin?, to: :user

  attr_reader :user
end
