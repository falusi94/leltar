class RightDecorator < ApplicationDecorator
  delegate_all
  include Draper::LazyHelpers

  def type_icon
    if right.write
      content_tag(:span, '', 'uk-icon': 'pencil', 'uk-tooltip': 'Szerkesztési jogosultság')
    else
      content_tag(:span, '', 'uk-icon': 'user', 'uk-tooltip': 'Olvasási jogosultság')
    end
  end

end
