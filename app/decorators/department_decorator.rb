# frozen_string_literal: true

class DepartmentDecorator < ApplicationDecorator
  decorates_finders
  decorates_association :department_users

  def edit_department_button
    return unless h.policy(object).edit?

    h.link_to(h.edit_label, h.edit_department_path(object), class: 'uk-button uk-button-secondary')
  end

  def delete_department_button
    return unless h.policy(object).destroy?

    h.link_to(h.delete_label, object, method: :delete, data: { confirm: h.t('form.actions.are_you_sure') },
                                      class: 'uk-button uk-button-danger')
  end
end
