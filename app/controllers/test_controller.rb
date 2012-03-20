class TestController < ApplicationController
  before_filter :authenticate

  def fetch
    fetch = Fetch.new

    @feed_items = Hash.new
    Feed.all.each do |feed|
      @feed_items[feed] = fetch.by_feed(feed)
    end
  end

end


