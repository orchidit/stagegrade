class ReportsController < ApplicationController
  before_filter :require_user, :only => [ :new, :create, :spam ]

  def new
    @user_review = UserReview.find(params[:user_review_id])
    @report = Report.new
  end

  def create
    create_report
  end

  def spam
    create_report(true)
  end
  
  private
  def create_report(is_spam = false)
    @report = Report.new(params[:report])
    @user_review = UserReview.find(params[:user_review_id])

    @report.user_review = @user_review
    @report.posted_by = current_user
    @report.is_spam = is_spam

    respond_to do |format|
      if @report.save
        flash[:notice] = "Reported review as spam!"
        format.html { redirect_to(production_path(@user_review.production) + "#show=community") }
      else
        format.html { render :action => "new" }
      end
    end
  end
end
