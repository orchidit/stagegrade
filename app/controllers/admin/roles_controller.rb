class Admin::RolesController < Admin::AdminController
  # Super: show, new, create, update, destroy
  # Here: index, edit
  
  in_place_edit_for :role, :name
  
  def new
    redirect_index
  end
  
  def edit
    redirect_index
  end
end