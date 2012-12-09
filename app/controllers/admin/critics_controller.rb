class Admin::CriticsController < Admin::AdminController
  # Super: index, show, create, update, destroy
  # Here:  new, edit
  in_place_edit_for :critic, :name

  def index
    order = "id desc"
    if params[:sort_by] == "alpha"
      order = "name"
    end
    @critic = Critic.new
    @critics = Critic.paginate(:page => params[:page], :order => order)
  end

  def new
    redirect_index
  end

  def edit
    redirect_index
  end

  def create
    super(admin_critics_path)
  end

  def update
    super(admin_critics_path)
  end
end