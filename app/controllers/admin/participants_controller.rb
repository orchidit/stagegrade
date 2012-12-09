class Admin::ParticipantsController < Admin::AdminController
  # Super: index, show, create, update, destroy
  # Here:  new, edit
  in_place_edit_for :participant, :name

  def new
    redirect_index
  end
end