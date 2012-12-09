class WelcomeController < ApplicationController
  # Here: index

  def index
    store_location
    params = { :order => "median_score desc, average_score desc, play_sort_title" }
    @panels = Panel.in_order.all
    feed_setup

    respond_to do |format|
      format.html
      format.js
      format.atom
    end
  end

  def fb
    feed_setup
    respond_to do |format|
      format.atom
    end
  end

  private
  def feed_setup
    feed_productions = Production.feed_published.all(:order => "feed_published_at DESC")
    recent_posts = Post.published(:limit => 10, :order => "created_at DESC")

    @feed = (feed_productions + recent_posts).sort { |p,s|
      (s.published_at || Time.new) <=> (p.published_at || Time.new)
    }[0..9]

    first = @feed.sort { |p,s| (s.updated_at || Time.new) <=> (p.updated_at || Time.new) }.first
    @feed_published_at = feed_productions.first.feed_published_at
    @updated_at = (first ? first.updated_at : nil)
  end
end