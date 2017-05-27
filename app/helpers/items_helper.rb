require 'csv'
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
    if @filter
      res += "?filter=#{@filter}"
    end
    res
  end

  def generate_csv(items)
    CSV::generate do |csv|
      headers = ['id','name', 'description', 'group', 
                 'purchase_date', 'entry_date', 'last_check', 
                 'status', 'old_number']
      csv << CSV::Row.new(headers, headers, true)
      items.each do |item|
        csv << CSV::Row.new(headers, item.to_a)
      end
    end
  end
end
