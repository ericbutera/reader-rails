class ItemAddSanitized2 < ActiveRecord::Migration
  def up
    add_column :items, :sanitized, :text
  end

  def down
    remove_column :items, :sanitized
  end
end
