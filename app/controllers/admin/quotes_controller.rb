class Admin::QuotesController < Admin::AdminController
  def new
    redirect_to admin_quotes_path
  end
end
