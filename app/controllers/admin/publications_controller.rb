class Admin::PublicationsController < Admin::AdminController
  # Super: show, create, update, destroy
  # Here:  index, new, edit
  in_place_edit_for :publication, :name

  def index
    order = "id desc"
    if params[:sort_by] == "alpha"
      order = "name"
    end
    @publication = Publication.new
    @publications = Publication.paginate(:page => params[:page], :order => order)
  end

  def new
    redirect_index
  end

  def edit
    redirect_index
  end

  def create
    super(admin_publications_path)
  end

  def update
    super(admin_publications_path)
  end
end