class Admin::AccessCodesController < Admin::AdminController
  # Super: index, show, create, update, destroy
  # Here:  new, edit
  in_place_edit_for :access_code, :code
  in_place_edit_for :access_code, :email_expression
  in_place_edit_for :access_code, :max_uses
  in_place_edit_for :access_code, :role_name

  def new
    redirect_index
  end

  def edit
    redirect_index
  end
end