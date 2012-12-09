class Admin::PlaysController < Admin::AdminController
  # Super: index, show, create, update, destroy
  in_place_edit_for :play, :title

end