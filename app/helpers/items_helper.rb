module ItemsHelper
  def picture_url(item)
    "/items/#{item.id}/picture"
  end

  def version_link(id, v)
    "<a href=\"/items/#{id}/versions/#{v.index}\">#{v.created_at}</a>".html_safe
  end
end
