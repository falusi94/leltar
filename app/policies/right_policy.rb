# frozen_string_literal: true

class RightPolicy < ApplicationPolicy
  def create?
    user.admin
  end

  alias update? create?
  alias destroy? create?

  def permitted_attributes
    %i[group_id user_id write]
  end
end
