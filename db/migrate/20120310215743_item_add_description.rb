class ItemAddDescription < ActiveRecord::Migration
  def up
    add_column :items, :description, :text
  end

  def down
    remove_column :items, :description
  end
end
