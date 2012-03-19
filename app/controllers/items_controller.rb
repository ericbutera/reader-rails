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

  def viewed
    @item = Item.find(params[:id])
    @item.is_viewed = 1
    @item.save
    render :json => @item
    #respond_to do |format|
    #  format.json { render :json => @item }
    #end
  end

end

