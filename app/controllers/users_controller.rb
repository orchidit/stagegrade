class UsersController < ApplicationController
  # Here: show, new, edit, create, update

  before_filter :require_no_user, :only => [:new, :create]
  before_filter :require_user, :only => [:show, :edit, :update, :share]

  def new
    @user = User.new
  end

  def share
    @user = current_user
  end

  def show
    @user = current_user
    redirect_to edit_account_url
  end

  def edit
    @user = current_user
    redirect_to root_url if @user.nil? or (params[:id] and @user.id.to_s != params[:id])
    store_location
  end

  def create
    @user = User.new(params[:user])
    @user.role = Role.find_by_name("user") if @user.role_id.nil?

    if verify_recaptcha(:model => @user) and @user.save
      flash[:notice] = "Account registered!"
      SignupMailer.deliver_account_signup_notification(@user)
      redirect_back_or_default root_url
    else
      render :action => :new
    end
  end

  def update
    @user = @current_user # makes our views "cleaner" and more consistent
    if @user.update_attributes(params[:user])
      flash[:notice] = "Account updated!"
      redirect_to root_url
    else
      render :action => :edit
    end
  end

  def fb_connected
    if current_user
      # A logged in user connected, which means that they are linking an existing account.
    else
      # A non-logged in user clicked an FB login button, so sign them up. Do we want to distinguish between new and returning users?
      User.new
    end
  end
end
