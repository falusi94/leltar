# frozen_string_literal: true

class ItemPolicy < ApplicationPolicy
  def show?
    user.can_read?(record.group_id)
  end

  def edit?
    user.can_write?(record.group_id)
  end
  alias update?            edit?
  alias destory?           edit?
  alias update_last_check? edit?
end
