# frozen_string_literal: true

class LocationPolicy < ApplicationPolicy
  def index?
    Pundit.policy(auth_scope, organization).index_location?
  end
  alias show? index?

  def new?
    Pundit.policy(auth_scope, organization).create_location?
  end
  alias create? new?

  def edit?
    user.authorized_to?(:update_location, organization: record.organization)
  end
  alias update? edit?

  def destroy?
    user.authorized_to?(:destroy_location, organization: record.organization)
  end

  def permitted_attributes
    %i[name]
  end

  class Scope < Scope
    def resolve
      scope.where(organization: organization)
    end
  end
end
