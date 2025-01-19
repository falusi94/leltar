# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :auth_scope, :record

  def initialize(auth_scope, record)
    @auth_scope = auth_scope
    @record     = record
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  delegate :user, :organization, to: :auth_scope

  class Scope
    attr_reader :user, :organization, :scope

    def initialize(auth_scope, scope)
      @user         = auth_scope.user
      @organization = auth_scope.organization
      @scope        = scope
    end

    def resolve
      scope.all
    end
  end
end
