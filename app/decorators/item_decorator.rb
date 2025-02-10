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

    h.image_tag(photo, class: 'uk-align-center')
  end

  def compact_name
    department_tag = h.content_tag(:span, class: 'uk-text-muted') { "(#{department.name})" }

    h.link_to("#{item.name} #{department_tag}".html_safe, h.item_path(object)) # rubocop:disable Rails/OutputSafety
  end

  def edit_button
    return unless h.policy(department).update_item?

    h.link_to(h.edit_label, h.edit_item_path(item),
              class: 'uk-button uk-button-secondary uk-button-small')
  end

  def check_form
    return unless h.policy(object).update?

    h.render 'web/items/check_form'
  end

  def parent_link
    return h.t('form.item.parent_missing') unless child?

    h.link_to(parent.name, h.item_path(parent))
  end

  def truncated_description
    description&.truncate 50
  end
end
