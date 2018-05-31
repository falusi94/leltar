class ImportCsv
  #Applies updates received in a CSV file, returns items where the update failed
  def self.call(text)
    rows = CSV.parse text
    header = rows[0]
    Rails.logger.debug "headers: "+ header.inspect
    id_col = header.find_index('id')
    attributes = Item.new.attributes
    bad_items = []
    rows.drop(1).each do |row|
      doc = Hash.new
      Rails.logger.debug "row: #{row.inspect}"
      row.each_index do |i|
        if header[i] != 'id' && (attributes.include?(header[i]) || header[i] == 'group')
          doc.store(header[i], row[i])
          Rails.logger.debug "stored #{header[i]}: #{row[i].inspect}"
        end
      end
      Rails.logger.debug "item: #{doc.inspect}"

      begin
        id = id_col && Integer(row[id_col])
      rescue
        id = nil
      end
      item = nil
      if id
        item = Item.find_by_id(id)
      end
      if !item || !id
        item = Item.new
      end

      item.update(doc)
      if ! item.valid?
        Rails.logger.debug "Errors: #{item.errors.full_messages.inspect}"
        bad_items.push(item)
      end
      item.save
    end
    bad_items
  end

end
