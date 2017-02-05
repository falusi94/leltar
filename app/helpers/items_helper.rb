module ItemsHelper
  def picture_url(item)
    "/items/#{item.id}/picture"
  end
end
