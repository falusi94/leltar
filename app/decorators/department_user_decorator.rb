# frozen_string_literal: true

class DepartmentUserDecorator < ApplicationDecorator
  def type_icon
    if write
      h.content_tag(:span, '', 'uk-icon': 'pencil', 'uk-tooltip': h.t('form.department_user.edit'))
    else
      h.content_tag(:span, '', 'uk-icon': 'user', 'uk-tooltip': h.t('form.department_user.read'))
    end
  end
end
