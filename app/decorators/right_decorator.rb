# frozen_string_literal: true

class RightDecorator < ApplicationDecorator
  def type_icon
    if write
      h.content_tag(:span, '', 'uk-icon': 'pencil', 'uk-tooltip': 'Szerkesztési jogosultság')
    else
      h.content_tag(:span, '', 'uk-icon': 'user', 'uk-tooltip': 'Olvasási jogosultság')
    end
  end
end
