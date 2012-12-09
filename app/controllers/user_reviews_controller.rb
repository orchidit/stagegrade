class UserReviewsController < ApplicationController
  before_filter :require_user, :only => [ :new, :create, :vote_up, :vote_down ]
  before_filter :only => [ :edit, :update, :destroy ] do |c| c.require_same_user end

  def index
    @reviews = UserReview.all(:order => "created_at DESC")

    respond_to do |format|
      format.html
    end
  end

  def new
    @user_review = UserReview.new
    @production = Production.find(params[:production_id])
  end

  def create
    @user_review = UserReview.new(params[:user_review])
    @production = Production.find(params[:production_id])

    @user_review.production = @production
    @user_review.posted_by = current_user
    @user_review.production_url = production_url(@user_review.production) + "#show=community"

    respond_to do |format|
      if @user_review.save
        flash[:notice] = "User review was successfully created."
        format.html { redirect_to(@user_review.production_url) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def edit
    @user_review = UserReview.find(params[:id])
    @production = @user_review.production
  end

  def update
    @user_review = UserReview.find(params[:id])
    @production = @user_review.production

    respond_to do |format|
      if @user_review.update_attributes(params[:user_review])
        flash[:notice] = "Review was successfully updated."
        format.html { redirect_to(production_path(@user_review.production) + "#show=community") }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @user_review = UserReview.find(params[:id])
    @production = @user_review.production
    @user_review.destroy

    respond_to do |format|
      format.html { redirect_to(production_path(@production) + "#show=community") }
    end
  end

  def require_same_user
    ur = UserReview.find(params[:id])

    unless current_user and current_user.id == ur.posted_by_id
      flash[:notice] = "You are not the creator of this review."
      redirect_to production_path(ur.production) + "#show=community"
    end
  end

  def vote_up
    vote(:up)
  end

  def vote_down
    vote(:down)
  end

  def undo_vote
    @vote = Vote.find_or_create_by_user_id_and_user_review_id(:user_id => current_user.id,
        :user_review_id => params[:id])
    dir = @vote.up ? :up : :down
    user_review = @vote.user_review

    respond_to do |format|
      @vote.destroy if !@vote.nil?
      format.html { redirect_to(production_path(@vote.user_review.production) + "#show=community") }
      format.js {
        render :partial => "vote_button", :locals => { :user_review => user_review, :direction => dir }
      }
    end
  end

  private
  def vote(direction)
    @vote = Vote.find_or_create_by_user_id_and_user_review_id(:user_id => current_user.id,
        :user_review_id => params[:id])
    @vote.up = (direction == :up ? true : false)

    respond_to do |format|
      if @vote.save
        flash[:notice] = "Thanks for voting!"
      else
        flash[:notice] = "Could not save vote."
      end
      format.html { redirect_to(production_path(@vote.user_review.production) + "#show=community") }
      format.js {
        render :partial => "vote_button", :locals => {  :user_review => @vote.user_review, :direction => direction }
      }
    end
  end
end
