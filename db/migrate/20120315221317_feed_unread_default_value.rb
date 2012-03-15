class FeedUnreadDefaultValue < ActiveRecord::Migration
  def up
    change_column :feeds, :unread, :integer, :default => 0
  end

  def down
  end
end

