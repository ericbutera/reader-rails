class Feed < ActiveRecord::Base
  attr_accessible :title, :url, :updated, :added, :entries, :unread, :created_at, :updated_at
  has_many :items

  default_scope order('feeds.added DESC')

  def self.fetch_all
    fetch = Fetch.new
    feed_items = Hash.new
    Feed.all.each do |feed|
      feed_items[feed] = fetch.by_feed(feed)
      logger.info "feed #{feed.id} fetched #{feed_items.length} with #{fetch.new_items.length} new"
    end
  end

end

