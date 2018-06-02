module GroupsHelper
  def new_group_button
    return unless current_user.admin
    link_to('Új kör', new_group_path, class: 'uk-button uk-button-primary uk-button-small')
  end
end
