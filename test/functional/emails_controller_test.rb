require 'test_helper'

class EmailsControllerTest < ActionController::TestCase
  def test_should_subscribe
    assert_difference('Email.active.count') do
      post :do_subscribe, :email => { :address => "a@a.com" }
    end
    assert_redirected_to root_url
    assert_equal flash[:notice], "You have subscribed."
  end

  def test_should_not_subscribe_with_no_email
    assert_no_difference('Email.active.count') do
      post :do_subscribe
    end
    assert_redirected_to root_url
    assert_equal flash[:notice], "Address can't be blank."
  end

  def test_should_not_subscribe_twice
    post :do_subscribe, :email => { :address => "a@a.com" }

    assert_no_difference('Email.active.count') do
      post :do_subscribe, :email => { :address => "a@a.com" }
    end
    assert_redirected_to root_url
    assert_equal flash[:notice], "Address is already subscribed."
  end

  def test_should_not_subscribe_existing_user
    user = {
      :email => "a@a.com",
      :crypted_password => "asd",
      :role_id  => "user",
      :password_salt => "asd",
      :persistence_token => "asd",
      :single_access_token => "asd",
      :perishable_token => "asd"
    }
    User.new(user).save(false)

    assert_no_difference('Email.active.count') do
      post :do_subscribe, :email => { :address => "a@a.com" }
    end
    assert_redirected_to edit_account_url
    assert_equal flash[:notice], "You already have an account. Make sure you have the option to receive emails from us enabled."
  end

  def test_should_unsubscribe
    post :do_subscribe, :email => { :address => "a@a.com" }

    assert_difference('Email.inactive.count') do
      post :do_unsubscribe, :email => { :address => "a@a.com" }
    end
    assert_redirected_to root_url
    assert_equal flash[:notice], "You have been unsubscribed. Were we too annoying? Send us feedback at <a href=\"mailto:contact@stagegrade.com\">contact@stagegrade.com</a>."
  end

  def test_should_not_unsubscribe_with_no_email
    assert_no_difference('Email.inactive.count') do
      post :do_unsubscribe
    end
    assert_redirected_to root_url
    assert_equal flash[:notice], "No email address provided."
  end

  def test_should_not_unsubscribe_twice
    post :do_subscribe, :email => { :address => "a@a.com" }
    post :do_unsubscribe, :email => { :address => "a@a.com" }

    assert_no_difference('Email.active.count') do
      post :do_unsubscribe, :email => { :address => "a@a.com" }
    end
    assert_redirected_to root_url
    assert_equal flash[:notice], "You have already unsubscribed."
  end

  def test_should_not_unsubscribe_unfound_email
    assert_no_difference('Email.active.count') do
      post :do_unsubscribe, :email => { :address => "a@a.com" }
    end
    assert_redirected_to root_url
    assert_equal flash[:notice], "Couldn't find your email address. Please try again."
  end

  def test_should_not_unsubscribe_existing_user
    user = {
      :email => "a@a.com",
      :crypted_password => "asd",
      :role_id  => "user",
      :password_salt => "asd",
      :persistence_token => "asd",
      :single_access_token => "asd",
      :perishable_token => "asd"
    }
    User.new(user).save(false)

    assert_no_difference('Email.active.count') do
      post :do_unsubscribe, :email => { :address => "a@a.com" }
    end
    assert_redirected_to new_user_session_url
    assert_equal flash[:notice], "You have an account. To stop receiving emails from us, uncheck the option to receive our emails."
  end
end
