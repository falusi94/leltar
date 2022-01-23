module GroupsHelper
  def new_group_button
    return unless current_user.admin

    link_to(new_label, new_group_path, class: 'uk-button uk-button-primary uk-button-small')
  end

  def users_with_no_access_to_group(group)
    User.where(admin: [false, nil], read_all_group: [false, nil]).where_assoc_not_exists(:groups, id: group.id)
  end
end
