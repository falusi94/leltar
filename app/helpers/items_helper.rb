module ItemsHelper
  def new_item_button
    if @group && current_user.can_write?(@group.id)
      link_to(new_label, new_group_item_path, class: 'uk-button uk-button-primary uk-button-small')
    elsif current_user.can_edit_groups?
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
    link_to(ver.created_at, "/items/#{id}/versions/#{ver.index}")
  end

  def csv_link
    return "/groups/#{@group}.csv" if @group

    '/items.csv'
  end
end
