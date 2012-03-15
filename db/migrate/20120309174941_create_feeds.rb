class CreateFeeds < ActiveRecord::Migration
  def change
    create_table :feeds do |t|
      t.string :title
      t.string :url
      t.datetime :updated
      t.datetime :added
      t.integer :entries
      t.integer :unread

      t.timestamps
    end
  end
end
