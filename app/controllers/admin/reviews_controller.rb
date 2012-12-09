class Admin::ReviewsController < Admin::AdminController
  # Super: show, new, edit, create, update, destroy
  # Here: index

  def index
    order = "productions.id desc, reviews.id asc"
    if params[:sort_by] == "alpha"
      order = "productions.play_title"
    elsif params[:sort_by] == "newest_reviews"
      order = "reviews.id desc"
    end

    if params[:show] == "is_playing"
      @reviews = Review.playing.paginate(:page => params[:page], :order => order)
    else
      @reviews = Review.paginate(:page => params[:page], :joins => :production, :order => order)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @reviews }
    end
  end

  def create
    super(new_admin_review_path)
  end

end