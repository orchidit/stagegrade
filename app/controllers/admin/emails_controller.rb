class Admin::EmailsController < Admin::AdminController
  # Super: index, show, create, update, destroy

  def index
    order = "id desc"
    if params[:sort_by] == "alpha"
      order = "address"
    end

    @emails = Email.paginate(:page => params[:page], :order => order)
  end

  def new
    redirect_index
  end

  def edit
    redirect_index
  end
end