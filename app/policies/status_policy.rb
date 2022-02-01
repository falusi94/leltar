# frozen_string_literal: true

class StatusPolicy < ApplicationPolicy
  def index?
    user.admin
  end
end
