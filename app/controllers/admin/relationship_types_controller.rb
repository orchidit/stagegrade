class Admin::RelationshipTypesController < Admin::AdminController
  # Super: index, show, edit, create, update, destroy
  # Here: new
  in_place_edit_for :relationship_type, :name
  in_place_edit_for :relationship_type, :default_connector

  def new
    redirect_to :action => "index"
  end
end
