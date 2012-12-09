class Admin::TheatresController < Admin::AdminController
  # Super: index, show, new, edit, create, update, destroy
  def show
    redirect_index
  end

  def create
    super(admin_theatres_path)
  end

  def update
    super(admin_theatres_path)
  end
end