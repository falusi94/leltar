class GroupDecorator < ApplicationDecorator
  decorates_finders
  delegate_all
  include Draper::LazyHelpers

  decorates_association :rights

  def edit_group_button
    return unless current_user.admin

    link_to(edit_label, edit_group_path(group), class: 'uk-button uk-button-secondary')
  end

  def delete_group_button
    return unless current_user.admin

    link_to(delete_label, group, method: :delete, data: { confirm: t(:are_you_sure_to_delete) },
                                 class: 'uk-button uk-button-danger')
  end
end
