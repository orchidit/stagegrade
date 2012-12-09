class Admin::PanelsController < Admin::AdminController
  # Super: index, show, new, edit, create, update, destroy
  def index
    @panels = Panel.in_order
  end

  def move_up
    Panel.find(params[:id]).move(:up)
    redirect_to admin_panels_path
  end
  
  def move_down
    Panel.find(params[:id]).move(:down)
    redirect_to admin_panels_path
  end
end