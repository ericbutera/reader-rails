class Feed < ActiveRecord::Base
  attr_accessible :title, :url, :updated, :added, :entries, :unread, :created_at, :updated_at
  has_many :items

  default_scope order('feeds.added DESC')

  def self.fetch_all
    fetch = Fetch.new
    feed_items = Hash.new
    Feed.all.each do |feed|
      feed_items[feed] = fetch.by_feed(feed)
    end

    # update counts: todo, make this only += new_items.length
    counts = Item.count(:all, :conditions => ['is_viewed=0'], :group=>:feed_id)
    Feed.all.each do |feed|
      orig = feed.unread
      feed.unread = counts[feed.id]
      puts "#{feed.id} newcount #{counts[feed.id]} old: #{orig}"
      feed.save
    end
  end

end

