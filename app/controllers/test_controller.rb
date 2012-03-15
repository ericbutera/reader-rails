class TestController < ApplicationController

  def fetch
    fetch = Fetch.new

    @feed_items = Hash.new
    Feed.all.each do |feed|
      @feed_items[feed] = fetch.by_feed(feed)
    end
  end

end


