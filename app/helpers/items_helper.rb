require 'csv'
module ItemsHelper
  def picture_url(item)
    "/items/#{item.id}/picture"
  end

  def version_link(id, v)
    "<a href=\"/items/#{id}/versions/#{v.index}\">#{v.created_at}</a>".html_safe
  end

  def generate_csv(items)
    CSV::generate do |csv|
      headers = ['id','Megnevezes', 'Leiras', 'Kor', 
                 'Beszerzes', 'Bevitel', 'Utolso ellenorzes', 
                 'Statusz', 'Regi szam']
      csv << CSV::Row.new(headers, headers, true)
      items.each do |item|
        csv << CSV::Row.new(headers, item.to_a)
      end
    end
  end
end
