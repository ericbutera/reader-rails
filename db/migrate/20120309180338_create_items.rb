class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :feed_id
      t.string :title
      t.string :url
      t.string :guid
      t.datetime :added, :default => Time.now
      t.integer :is_viewed, :default => 0

      t.timestamps
    end
  end
end
