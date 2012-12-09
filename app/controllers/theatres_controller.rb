class TheatresController < ApplicationController
  # Here: index, show

  def index
    @alpha_theatres = Theatre.all(:order => "name")
    @latest_theatres = Theatre.ordered_by_latest_review

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @theatres }
    end
  end

  # GET /theatres/1
  # GET /theatres/1.xml
  def show
    @theatre = Theatre.find(params[:id])
    @review_counts = Review.count(:all, :group => "production_id")
    @user_review_counts = UserReview.count(:all, :group => "production_id")

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @theatre }
    end
  end
end
