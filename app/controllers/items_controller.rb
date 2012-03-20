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
    if @item.is_viewed == 0 then
      @item.is_viewed = 1
      @item.save

      @feed = Feed.find(@item.feed_id)
      @feed.unread = @feed.unread - 1
      @feed.save
    end

    # TODO send feed too to update navlinks feed count
    render :json => @item
    #respond_to do |format|
    #  format.json { render :json => @item }
    #end
  end

  def sanitized 
    @item = Item.find(params[:id])
    render :inline => @item.sanitized
  end

end

