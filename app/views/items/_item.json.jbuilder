json.extract! item, :id, :name, :description, :purchase_date, :entry_date, :last_check, :status, :old_number, :created_at, :updated_at
json.group item.group.name
json.url item_url(item, format: :json)
photo = item.photos.first
if photo
  json.picture photo.url(:medium)
  json.thumb photo.url(:thumb)
else
  json.picture ''
  json.thumb ''
end
