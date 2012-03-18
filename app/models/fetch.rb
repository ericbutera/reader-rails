require 'nokogiri'
require 'open-uri'
require 'time'
require 'date'

class Fetch

  attr_accessor :new_items

  def initialize
    @sanitizer = HTML::Sanitizer.new
    @new_items = []
  end

  def by_feed(feed)
    @new_items[feed.id] = 0
    # generate item entries from rss
    doc = Nokogiri::XML(open(feed.url))
    items = doc.xpath('//item').map do |i|
      item = by_item(feed, i)
    end
  end

  def by_item(feed, raw)
    # generate an Item from a nokogiri xml entry
    """
    - load by guid if guid exists
    - else load by url but limit time range to within a week
    """
    guid = raw.xpath('guid').text;
    if (guid.length > 0)
      item = Item.by_guid(feed.id, guid)
      if (!item.nil?)
        item.title = item.title # + " found by guid"
        return item
      end
    end

    url = raw.xpath('link').text
    item = Item.by_url(feed.id, url)
    if (!item.nil?)
      item.title = item.title # + " found by url"
      return item
    end

    date = DateTime.now
    pubDate = raw.xpath('pubDate').text
    pub = date
    if (pubDate.length > 0)
      begin
        pub = DateTime.parse(pubDate);
      rescue
      end
    end

    desc = raw.xpath('description').text
    current = {
      :feed_id     => feed.id,
      :title       => raw.xpath('title').text,
      :url         => url,
      :guid        => guid,
      :description => desc,
      :sanitized   => @sanitizer.sanitize(desc),
      :added       => date,
      :pub_date    => pub,
      :updated_at  => date
    }
    @new_items[feed.id] = @new_items[feed.id] + 1
    item = Item.new(current)
    item.save
    return item
  end

end

