# frozen_string_literal: true

module ItemsHelper
  def new_item_button(department)
    if department && policy(department).write_items?
      link_to(new_label, new_department_item_path, class: 'uk-button uk-button-primary uk-button-small')
    elsif policy(Item).new?
      link_to(new_label, new_item_path, class: 'uk-button uk-button-primary uk-button-small')
    end
  end

  def items_page_title(department)
    if department
      "Item(s) of #{department.name}"
    else
      'Item(s)'
    end
  end

  def version_link(id, ver)
    link_to(ver.created_at, item_version_path(id, ver.index))
  end

  def parent_item_candidates(item)
    @parent_item_candidates ||= begin
      items = (item&.department&.items || Item.all).not_a_child

      ItemDecorator.decorate_collection(items)
    end
  end
end
