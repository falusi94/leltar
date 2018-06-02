class ItemDecorator < ApplicationDecorator
  delegate_all
  include Draper::LazyHelpers

  def photo
    return unless item.photos.any?
    image_tag(item.photos.last.url, style:'height:100px', class: 'uk-align-right')
  end

  def compact_name
    group_name = "(#{item.group.name})"
    group_tag = content_tag(:span, group_name, class: 'uk-text-muted')
    link_to item_path(item) do
      "#{item.name} #{group_tag}".html_safe
    end
  end

  def edit_title
    "#{name} szerkeszése"
  end

  def edit_button
    return unless current_user.can_write?(group.id)
    link_to('Szerkesztés', edit_item_path(item),
            class: 'uk-button uk-button-secondary uk-button-small')
  end

  def check_form
    return unless current_user.can_write?(group.id)
    form_tag check_item_path, method: :post, class: 'uk-form' do
      submit_tag('Rendben van!', class: 'uk-button uk-button-primary')
    end
  end

end
