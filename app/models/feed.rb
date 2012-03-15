class Feed < ActiveRecord::Base
  attr_accessible :title, :url, :updated, :added, :entries, :unread, :created_at, :updated_at
  has_many :items

  default_scope order('feeds.title')
end

