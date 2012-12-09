# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirmation

  # authlogic
  helper_method :current_user_session, :current_user, :current_fb_session, :fb_user_id, :is_admin, :is_super_user

  cache_sweeper :panels_sweeper, :only => [ :create, :update, :destroy ]

  def new
    redirect_root
  end

  def edit
    redirect_root
  end

  def create
    redirect_root
  end

  def update
    redirect_root
  end

  def destroy
    redirect_root
  end

  private
  def redirect_root
    redirect_to :root
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)

    @current_user_session = UserSession.find

    # If no session found, but FB cookie exists and FB ID matches an SG user,
    # create the session and update the access token.

    if !@current_user_session and fb_user_id and user = User.find_by_fb_user_id(fb_user_id)
      @current_user_session = UserSession.create(user, true)
      @current_user_session.user.update_attributes(:fb_access_token => fb_access_token)
    end

    @current_user_session
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session.try(:user)
  end

  def current_fb_session
    return @current_fb_session if defined?(@current_fb_session)
    begin
      @current_fb_session = fb_oauth.get_user_info_from_cookies(cookies)
    rescue Koala::Facebook::APIError => e
      if e.fb_error_type == "OAuthException"
        @current_fb_session = nil
      else
        raise e
      end
    end

    @current_fb_session
  end

  def fb_user_id
    current_fb_session.try(:[], "user_id")
  end

  def fb_access_token
    current_fb_session.try(:[], "access_token")
  end

  def fb_oauth
    @oauth ||= Koala::Facebook::OAuth.new(ENV["FB_APP_ID"], ENV["FB_SECRET"])
  end

  def auth_status
    status_class = Struct.new("AuthStatus", :has_sg_user, :has_fb_user)
    status = status_class.new
    status.has_sg_user = !current_user.nil?
    status.has_fb_user = !fb_user_id.nil?
    status
  end

  def require_user
    status = auth_status

    if status.has_sg_user
      true
    elsif status.has_fb_user
      store_location
      if request.xhr?
        render :json => { :status => "ok", :url => associate_facebook_path }
      else
        redirect_to associate_facebook_path
      end

      return false
    else
      store_location
      flash[:notice] = "You must be logged in to access this page"

      if request.xhr?
        render :json => { :status => "ok", :url => new_user_session_path }
      else
        redirect_to new_user_session_path
      end

      return false
    end
  end

  def require_admin
    unless is_admin
      if current_user
        flash[:notice] = "You must be an administrator to access this page"
        redirect_back_or_default root_url
        return false
      else
        require_user
      end
    end
    return true
  end

  def require_super_user
    unless is_super_user or is_super_user
      if current_user
        flash[:notice] = "You must be a super user to access this page"
        redirect_back_or_default root_url
        return false
      else
        require_user
      end
    end
    return true
  end

  def is_admin
    current_user and current_user.admin?
  end

  def is_super_user
    current_user and (current_user.super_user? or current_user.admin?)
  end

  def require_no_user
    if current_user
      store_location

      if request.xhr?
        render :json => { :status => "ok", :url => edit_account_path }
      else
        redirect_to edit_account_path
      end

      return false
    end
  end

  def store_location
    session[:return_to] = request.request_uri
  end

  def redirect_back_or_default(default)
    if request.xhr?
      render :json => { :status => "ok", :url => (session[:return_to] || default) }
    else
      redirect_to(session[:return_to] || default)
    end
    session[:return_to] = nil
  end

  # Custom 404/500
  def render_optional_error_file(status_code)
    activate_authlogic
    if status_code == :internal_server_error
      render_500 and return
    elsif status_code == :not_found
      render_404 and return
    else
      super
    end
  end

  def render_404
    respond_to do |type|
      type.html { @page = Page.find_by_slug("404"); render :template => "pages/show", :slug => "404", :status => 404 }
      type.all  { render :nothing => true, :status => 404 }
    end
    true  # so we can do "render_404 and return"
  end

  def render_500
    respond_to do |type|
      type.html { @page = Page.find_by_slug("500"); render :template => "pages/show", :slug => "500", :status => 500 }
      type.all  { render :nothing => true, :status => 500 }
    end
    true  # so we can do "render_500 and return"
  end
end
