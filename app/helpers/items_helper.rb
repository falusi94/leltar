module ItemsHelper
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
