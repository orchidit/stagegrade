class ReviewersController < ApplicationController
  # Here: index, show

  EXCEPT_MAP = {
    "critics" => [:publications],
    "publications" => [:critics]
  }

  def index
    index_with_block
  end

  def show
    show_with_block
  end


  private
  def index_with_block(&block)
    sort_map = {
      "grade_desc" => ["median_score", 0, :desc],
      "grade_asc" => ["median_score", 1000, :asc],
      "latest" => ["review_updated_at", 100.days.ago, :desc],
      "alpha" => ["name", "z", :asc]
    }

    show = params[:show] || nil
    sort = sort_map[params[:sort]] || sort_map["alpha"]

    @reviewers = Reviewer.all(:show => show, :order => "#{sort[0]} #{sort[2]}").select(&:is_published_site)

    if block_given?
      yield
    else
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @reviewers }
      end
    end
  end

  def show_with_block(&block)
    sort_map = {
      "grade_desc" => ["score", 0, :desc],
      "grade_asc" => ["score", 1000, :asc],
      "latest" => ["updated_at", 100.days.ago, :desc]
    }

    sort = sort_map[params[:sort]] || sort_map["grade_desc"]
    ivar = controller_name.singularize.downcase
    instance_variable_set ("@" + ivar).to_sym, Kernel.const_get(ivar.capitalize).find(params[:id])
    @reviews = Reviewer.sort(instance_variable_get("@" + ivar).published_reviews, sort[0], sort[1], sort[2])

    if block_given?
      yield
    else
      respond_to do |format|
        format.html # show.html.erb
        format.xml  { render :xml => instance_variable_get("@" + ivar) }
      end
    end
  end
end