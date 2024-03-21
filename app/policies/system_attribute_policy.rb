# frozen_string_literal: true

class SystemAttributePolicy < ApplicationPolicy
  def edit?
    user.admin
  end

  alias update? edit?
  alias index? edit?
end
