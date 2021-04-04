# frozen_string_literal: true

class ItemPolicy < ApplicationPolicy
  def edit?
    user.can_write?(record.group_id)
  end
end
