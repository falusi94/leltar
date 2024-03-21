# frozen_string_literal: true

module DepartmentsHelper
  def new_department_button
    return unless policy(Department).new?

    link_to(new_label, new_department_path, class: 'uk-button uk-button-primary uk-button-small')
  end

  def users_with_no_access_to_department(department)
    User
      .where(admin: [false, nil], read_all_department: [false, nil])
      .where_assoc_not_exists(:departments, id: department.id)
  end
end
