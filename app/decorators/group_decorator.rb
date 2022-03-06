# frozen_string_literal: true

class GroupDecorator < ApplicationDecorator
  decorates_finders
  decorates_association :rights

  def edit_group_button
    return unless h.policy(object).edit?

    h.link_to(h.edit_label, h.edit_group_path(object), class: 'uk-button uk-button-secondary')
  end

  def delete_group_button
    return unless h.policy(object).destroy?

    h.link_to(h.delete_label, object, method: :delete, data: { confirm: h.t('form.actions.are_you_sure') },
                                      class: 'uk-button uk-button-danger')
  end
end
