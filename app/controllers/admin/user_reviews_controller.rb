class Admin::UserReviewsController < Admin::AdminController
  # Super: index, edit, show, create, update, destroy
  # Here:  new
  def new
    redirect_index
  end

  def index
    order = "id desc"
    if params[:sort_by] == "useful"
      order = "up_vote_count desc"
    end

    @user_reviews = UserReview.paginate(:page => params[:page], :order => order)
  end
end