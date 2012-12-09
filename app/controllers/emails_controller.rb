class EmailsController < ApplicationController
  def do_subscribe
    redirect = :root_url
    redirect_back = true
    status = :failure

    @email = Email.new(params[:email])
    @email.is_active = true

    if @email.save
      SignupMailer.deliver_email_list_signup_notification(@email)
      status = :success
      session.delete :source
    else
      redir = @email.get_redirect_values
      redirect, redirect_back = redir[:redirect], redir[:redirect_back]
    end

    flash[:notice] = (status == :success ? "You have subscribed." : @email.errors.full_messages.join("\n"))

    respond_to do |format|
      format.html {
        redirect_back ? redirect_back_or_default(send(redirect)) : redirect_to(send(redirect))
      }
      format.js {
        render :partial => "sign_up_box", :locals => { :status => status }
      }
    end
  end

  def do_unsubscribe
    redirect = :root_url
    redirect_back = true
    status = :failure

    if params[:email].nil? or params[:email][:address].nil?
      flash[:notice] = "No email address provided."
    elsif User.find_by_email(params[:email][:address])
      flash[:notice] = "You have an account. To stop receiving emails from us, uncheck the option to receive our emails."
      redirect = :new_user_session_url
      redirect_back = false
    else
      @email = Email.find_by_address(params[:email][:address])

      if @email.nil?
        flash[:notice] = "Couldn't find your email address. Please try again."
      else
        @email.is_active = false
        if @email.is_active_was == false
          flash[:notice] = "You have already unsubscribed."
        elsif @email.save
          flash[:notice] = "You have been unsubscribed. Were we too annoying? Send us feedback at <a href=\"mailto:contact@stagegrade.com\">contact@stagegrade.com</a>."
        else
          flash[:notice] = "We couldn't unsubscribe you. Please try again or contact us at <a href=\"mailto:contact@stagegrade.com\">contact@stagegrade.com</a>."
        end
      end
    end
    redirect_back ? redirect_back_or_default(send(redirect)) : redirect_to(send(redirect))
  end

  def subscribe
    store_location
    @email = Email.new
  end

  def unsubscribe
    store_location
    @email = Email.new
  end
end
