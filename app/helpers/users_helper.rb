# frozen_string_literal: true

module UsersHelper
  def departments_without_access(user, organization)
    return [] if user.authorized_to?(:index_department, organization) # TODO: check why it fails with kwargs

    Department.where_assoc_not_exists(:users, id: user.id)
  end
end
