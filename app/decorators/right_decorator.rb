# frozen_string_literal: true

class RightDecorator < ApplicationDecorator
  def type_icon
    if write
      h.content_tag(:span, '', 'uk-icon': 'pencil', 'uk-tooltip': h.t('form.right.edit'))
    else
      h.content_tag(:span, '', 'uk-icon': 'user', 'uk-tooltip': h.t('form.right.read'))
    end
  end
end
