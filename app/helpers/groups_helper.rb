module GroupsHelper
  def new_group_button
    return unless current_user.admin

    link_to(new_label, new_group_path, class: 'uk-button uk-button-primary uk-button-small')
  end
end
