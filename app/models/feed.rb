class Feed < ActiveRecord::Base
  attr_accessible :title, :url, :updated, :added, :entries, :unread, :created_at, :updated_at
  has_many :items

  default_scope order('feeds.added DESC')

  def self.fetch_all
    fetch = Fetch.new
    feed_items = Hash.new
    feeds = Feed.all
    feeds.each do |feed|
      feed_items[feed] = fetch.by_feed(feed)
      logger.info "feed #{feed.id} fetched #{feed_items.length} with #{fetch.new_items.length} new"
    end

    # update counts: todo, make this only += new_items.length
    counts = Item.count(:all, :conditions => ['is_viewed=0'], :group=>:feed_id)
    feeds.each do |feed|
      feed.unread = counts[feed.id]
      feed.save
    end
  end

end

