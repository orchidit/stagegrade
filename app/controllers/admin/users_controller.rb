class Admin::UsersController < Admin::AdminController
  # Super: index, show, new, edit, create, update, destroy
  def email_list
    text = ""
    User.all(:conditions => { :allow_emails => true }).each do |u|
      text += u.email + "<br />"
    end
    render :text => text
  end
end