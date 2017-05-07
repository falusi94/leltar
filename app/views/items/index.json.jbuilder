json.items { json.array! @items, partial: 'items/item', as: :item }
json.count @item_count
