module ItemsHelper
  def new_item_button
    if @group && policy(@group).write_items?
      link_to(new_label, new_group_item_path, class: 'uk-button uk-button-primary uk-button-small')
    elsif policy(Item).new?
      link_to(new_label, new_item_path, class: 'uk-button uk-button-primary uk-button-small')
    end
  end

  def items_page_title
    return "#{@group.name} eszközei" if @group

    'Eszközök'
  end

  def picture_new_url(item)
    "/items/#{item.id}/photos"
  end

  def version_link(id, ver)
    link_to(ver.created_at, item_version_path(id, ver.index))
  end

  def csv_link
    return "/groups/#{@group}.csv" if @group

    '/items.csv'
  end
end
