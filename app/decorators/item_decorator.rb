class ItemDecorator < ApplicationDecorator
  delegate_all
  include Draper::LazyHelpers
  decorates_finders

  def photo
    return unless item.photos.any?

    image_tag(item.photos.last.url, class: 'uk-align-right')
  end

  def compact_name
    group_name = "(#{item.group.name})"
    group_tag = content_tag(:span, group_name, class: 'uk-text-muted')
    link_to "#{item.name} #{group_tag}".html_safe, item_path(item)
  end

  def edit_button
    return unless current_user.can_write?(group.id)

    link_to(edit_label, edit_item_path(item),
            class: 'uk-button uk-button-secondary uk-button-small')
  end

  def check_form
    return unless current_user.can_write?(group.id)

    render 'check_form'
  end

  def parent_link
    return 'nincs' unless child?

    link_to(parent.name, item_path(parent))
  end

  def truncated_description
    description&.truncate 50
  end
end
