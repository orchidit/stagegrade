class ProductionsController < ApplicationController
  # Here: index, show, archives

  def index
    @productions = Production.find_with_params(params)
    @review_counts = Review.count(:all, :group => "production_id")
    @user_review_counts = UserReview.count(:all, :group => "production_id")

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'production_list', :locals => { :show_explanation => false,
          :productions => @productions, :review_counts => @review_counts,
          :user_review_counts => @user_review_counts }
      }
      format.xml  { render :xml => @productions }
    end
  end

  def show
    @production = Production.find(params[:id])
    redirect_to :action => "index" and return unless @production.is_published_site or is_admin

    respond_to do |format|
      format.html { store_location }
      format.js { render :partial => "productions/reviews_pane" }
      format.xml  { render :xml => @production }
    end
  end
end
