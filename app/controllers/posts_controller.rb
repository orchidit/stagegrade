class PostsController < ApplicationController
  # Here: index, show
  def index
    @posts = Post.published(:order => "created_at DESC")
    @feed_productions = Production.feed_published.all(:order => "feed_published_at DESC")
    @feed = (@feed_productions + @posts).sort { |p,s|
      (s.published_at || Time.new) <=> (p.published_at || Time.new)
    }
    page = params[:page].nil? ? 1 : params[:page].to_i
    range = Range.new((page - 1) * 10 + 1, page * 10)

    @paged_feed = @feed[range]
    @paged_feed.add_ivar("per_page", 10)
    @paged_feed.add_ivar("total_pages", (@feed.count / @paged_feed.per_page.to_f).ceil)
    @paged_feed.add_ivar("previous_page", [1, page - 1].max)
    @paged_feed.add_ivar("next_page", [@paged_feed.total_pages, page + 1].min)
    @paged_feed.add_ivar("current_page", page)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @posts }
    end
  end
  
  def show
    @post = Post.find(params[:id])
    redirect_to :action => "index" and return unless @post.is_published or is_admin

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @post }
    end
  end
end