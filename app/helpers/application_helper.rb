module ApplicationHelper
  def back_label
    create_label('arrow-left', 'Vissza')
  end

  def list_label
    create_label('menu', 'Összes listázása')
  end

  def edit_label
    create_label('pencil', 'Szerkesztés')
  end

  def new_label
    create_label('plus', 'Új hozzáadása')
  end

  def delete_label
    create_label('trash', 'Törlés')
  end

  private

  def create_label(icon_name, label_text)
    to_medium_tag = content_tag(:span, '', class: 'uk-hidden@m', 'uk-icon': icon_name)
    from_medium_tag = content_tag(:span, label_text, class: 'uk-visible@m')
    "#{to_medium_tag}#{from_medium_tag}".html_safe
  end
end
