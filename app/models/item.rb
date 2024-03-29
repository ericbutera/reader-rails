class Item < ActiveRecord::Base
  attr_accessible :feed_id, :title, :url, :guid, :added, :updated_at, :is_viewed, :description, :sanitized, :pub_date

  belongs_to :feed

  validates :url, :presence => true

  default_scope order('items.added DESC')
  scope :unread, lambda { |feed_id| where("items.feed_id=? AND items.is_viewed=0", feed_id) }
  scope :all, lambda { |feed_id| where("items.feed_id=?", feed_id) }
  scope :by_guid, lambda { |guid| where(:guid => guid) }

  def self.by_guid(feed_id, guid)
    Item.where("feed_id=? AND guid=?", feed_id, guid).first
  end

  def self.by_url(feed_id, url)
    Item.where("feed_id=? AND url=?", feed_id, url).first
  end

  def self.by_feed(feed_id, item_viewed_filter) 
    if (item_viewed_filter == 'all') 
      Item.all(feed_id).limit(25)
    else
      Item.unread(feed_id).limit(25)
    end
  end
end

