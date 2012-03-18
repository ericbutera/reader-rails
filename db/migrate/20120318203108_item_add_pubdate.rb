class ItemAddPubdate < ActiveRecord::Migration
  def up
    add_column :items, :pub_date, :datetime, :default => Time.now
  end

  def down
    remove_column :items, :pub_date
  end
end
