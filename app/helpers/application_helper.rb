module ApplicationHelper
  def menu
    @feeds = Feed.all
  end
end
