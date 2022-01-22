# frozen_string_literal: true

class RightPolicy < ApplicationPolicy
  def create?
    user.admin
  end

  alias update? create?
  alias destroy? create?
end
