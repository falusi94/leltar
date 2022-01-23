# frozen_string_literal: true

module UsersHelper
  def groups_without_access(user)
    return [] if user.admin || user.write_all_group

    Group.where_assoc_not_exists(:users, id: user.id)
  end
end
