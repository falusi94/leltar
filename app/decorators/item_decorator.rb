# frozen_string_literal: true

class ItemDecorator < ApplicationDecorator
  decorates_association :children, with: ItemDecorator

  decorates_finders

  def photo
    photo = if photos.attached?
              photos.last.variant(resize_to_fit: [600, 600])
            else
              'no_photo.gif'
            end

    h.image_tag(photo, class: 'uk-align-right')
  end

  def compact_name
    group_tag = h.content_tag(:span, class: 'uk-text-muted') { "(#{group.name})" }

    h.link_to("#{item.name} #{group_tag}".html_safe, h.item_path(object))
  end

  def edit_button
    return unless h.policy(group).write_items?

    h.link_to(h.edit_label, h.edit_item_path(item),
              class: 'uk-button uk-button-secondary uk-button-small')
  end

  def check_form
    return unless h.policy(object).update?

    h.render 'items/check_form'
  end

  def parent_link
    return h.t('form.item.parent_missing') unless child?

    h.link_to(parent.name, h.item_path(parent))
  end

  def truncated_description
    description&.truncate 50
  end
end
