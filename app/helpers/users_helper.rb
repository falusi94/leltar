# frozen_string_literal: true

module UsersHelper
  def departments_without_access(user)
    return [] if user.admin || user.write_all_department

    Department.where_assoc_not_exists(:users, id: user.id)
  end
end
