# frozen_string_literal: true

module ItemsHelper
  def new_item_button
    if @group && policy(@group).write_items?
      link_to(new_label, new_group_item_path, class: 'uk-button uk-button-primary uk-button-small')
    elsif policy(Item).new?
      link_to(new_label, new_item_path, class: 'uk-button uk-button-primary uk-button-small')
    end
  end

  def items_page_title
    if @group
      "Item(s) of #{@group.name}"
    else
      "Item(s)"
    end
  end

  def version_link(id, ver)
    link_to(ver.created_at, item_version_path(id, ver.index))
  end

  def parent_item_candidates
    @parent_item_candidates ||= begin
      items = (@item&.group&.items || Item.all).not_a_child

      ItemDecorator.decorate_collection(items)
    end
  end
end
