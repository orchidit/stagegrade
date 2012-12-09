class ReviewsController < ApplicationController
  # Here: index, show
  
  def index
    redirect_root
  end

  def show
    @review = Review.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @review }
    end
  end
end
