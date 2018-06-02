module ItemsHelper
  def new_item_button
    if @group && current_user.can_write?(@group.id)
      return link_to('Új eszköz', new_group_item_path,
                     class: 'uk-button uk-button-primary uk-button-small')
    elsif current_user.can_edit_groups?
      return link_to('Új eszköz', new_item_path,
                     class: 'uk-button uk-button-primary uk-button-small')
    end
  end

  def items_page_title
    return "#{@group.name} eszközei" if @group
    'Eszközök'
  end

  def picture_new_url(item)
    "/items/#{item.id}/photos"
  end

  def version_link(id, v)
    "<a href=\"/items/#{id}/versions/#{v.index}\">#{v.created_at}</a>".html_safe
  end

  def csv_link
    res = if @group
      "/groups/#{@group}.csv"
    else
      "/items.csv"
    end
    res
  end

end
