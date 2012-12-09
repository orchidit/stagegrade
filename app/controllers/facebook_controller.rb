class FacebookController < ApplicationController
  before_filter :require_no_user, :only => [ :associate, :create_user ]
  before_filter :require_user, :only => [ :create_session, :link_user, :unlink_user ]

  def associate
    @user = User.new
    @user_session = UserSession.new
  end

  def create_session
    # The cookie will have already been set, so all we need to do is check the auth_status.
    status = auth_status

    url = false

    if status.has_sg_user
      url = (session[:return_to] || root_url)
    elsif status.has_fb_user
      url = associate_facebook_path
    end

    if request.xhr?
      render :json => { :status => "ok", :url => url }
    else
      redirect_to(url || root_url)
    end
  end

  def create_user
    @user = User.new_from_fb_cookie_user(fb_access_token, fb_user_id)
    @user.role = Role.find_by_name("user") if @user.role_id.nil?

    if @user.save
      flash[:notice] = "Account registered!"
      SignupMailer.deliver_account_signup_notification(@user)
      @user_session = UserSession.create(@user, true)
      render :json => { :status => "ok", :url => (session[:redirect_to] || root_url) }
    else
      @user_session = UserSession.new
      render :json => { :status => "error", :message => @user.errors.full_messages.join("\n") }
    end
  end

  def link_user
    user = current_user
    user.fb_access_token = fb_access_token
    user.update_with_fb_me_hash(user.fb_graph_user)
    user.save

    if user.save
      render :json => { :status =>  "ok" }
    else
      render :json => { :status => "error", :message => user.errors.full_messages.join("\n") }
    end
  end

  def unlink_user
    current_user.fb_unlink
    current_user.save
    # render :json => { :status => "function", :function => "FB.logout" }
    render :json => { :status => "ok" }
  end
end
