class UserSessionsController < ApplicationController
  # Here: new, create, destroy

  before_filter :require_no_user, :only => [ :new, :create ]
  before_filter :require_user, :only => :destroy

  def new
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      @user_session.user.link_to_fb_cookie_user(fb_user_id)
      flash[:notice] = "Login successful!"
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end

  def destroy
    current_user_session.destroy

    if fb_user_id.nil?
      flash[:notice] = "Logout successful!"
    else
      flash[:notice] = "Since you are logged in using Facebook or have your account linked to Facebook, in order to " +
          "log out of StageGrade, you must also log out of Facebook.<br /><br />" +
          "<a href=\"#\" class=\"fb_logout\">Click here to log out of Facebook.</a>".html_safe
    end
    redirect_back_or_default root_url
  end
end
