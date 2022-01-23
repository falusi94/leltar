# frozen_string_literal: true

class ItemPolicy < ApplicationPolicy
  def show?
    Pundit.policy(user, record.group).read_items?
  end

  def edit?
    Pundit.policy(user, record.group).write_items?
  end
  alias update?  edit?
  alias destroy? edit?
  alias create?  edit?

  class Scope < Scope
    def resolve
      if user.admin || user.read_all_group
        scope.all
      else
        scope.where(group: user.groups)
      end
    end
  end
end
