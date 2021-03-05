# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def index?
    user.admin
  end

  def show?
    user.admin
  end

  def create?
    user.admin
  end

  def update?
    user.admin || user == record
  end

  def destroy?
    user.admin
  end

  def permitted_attributes
    if user.admin
      %i[name email password password_confirmation admin write_all_group read_all_group]
    else
      %i[email password password_confirmation]
    end
  end
end
