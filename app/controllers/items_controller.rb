class ItemsController < ApplicationController
  before_filter :authenticate

  def index 
    @feed_items = Hash.new
    Feed.all.each do |feed|
      @feed_items[feed] = Item.by_feed(feed)
    end
  end

  def feed
    # session[:item_viewed_filter] = 'unread'
    @item_viewed_filter = session[:item_viewed_filter] ||= 'unread' # need to abstract this somehow
    @feed = Feed.find(params[:feed_id])
    @items = Item.by_feed(@feed, @item_viewed_filter)
    #render :layout => "empty"

    #todo <- do this in feed.fetch_all
    html = render_to_string(partial: 'feed.html.erb', locals: { items: @items }) 
    html.gsub!(/\s\s+/, ' ')

    render :json => {
      :sort => @sort,
      :feed => @feed,
      :items => html,
      :item_viewed_filter => @item_viewed_filter
    }
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

