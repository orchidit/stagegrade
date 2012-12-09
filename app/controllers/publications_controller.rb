class PublicationsController < ReviewersController
  # Here: index, show

  def index
    @publications = Publication.all

    index_with_block {
      respond_to do |format|
        format.html { redirect_to(reviewers_path(:show => "publications")) }
        format.xml  { render :xml => @publications }
      end
    }
  end

  def show
    @publication = Publication.find(params[:id])

    show_with_block {
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => @publication }
      end
    }
  end
end
