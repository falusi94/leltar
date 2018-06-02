class UpdateItemsTable < ActiveRecord::Migration[5.0]
  def up
    add_column :items, :state, :integer, default: 0

    Item.where(status: 'OK'              ).update(state: :ok                   )
    Item.where(status: 'Selejtezésre vár').update(state: :waiting_for_scrapping)
    Item.where(status: 'Selejtezve'      ).update(state: :scrapped             )
    Item.where(status: 'Utána kell járni').update(state: :not_found            )
    Item.where(status: 'Elveszett'       ).update(state: :lost                 )
  end

  def down
    remove_column :items, :state
  end
end
