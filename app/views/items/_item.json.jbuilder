json.extract! item, :id, :name, :description, :purchase_date, :entry_date, :last_check, :status, :old_number, :created_at, :updated_at
json.group item.group.name
json.url item_url(item, format: :json)
json.picture item.picture.url(:medium)
json.thumb item.picture.url(:thumb)
