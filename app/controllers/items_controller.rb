class ItemsController < ApplicationController

  def index 
    @feed_items = Hash.new
    Feed.all.each do |feed|
      @feed_items[feed] = Item.by_feed(feed)
    end
  end

  def feed
    @feed = Feed.find(params[:feed_id])
    @items = Item.by_feed(@feed)
    render :layout => "empty"
  end

end

