class PagesController < ApplicationController
  def show
    page = Page.find_by_slug(params[:slug])
    render_404 and return if page.nil?
    @page = page
  end
end
