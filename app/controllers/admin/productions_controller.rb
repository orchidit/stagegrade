class Admin::ProductionsController < Admin::AdminController
  # Super: show, new, edit, create, update, destroy
  # Here: index
  def index
    order = "id desc"
    if params[:sort_by] == "alpha"
      order = "play_title"
    elsif params[:sort_by] == "opening_date"
      order = "opening_date"
    end

    if params[:show] == "is_playing"
      @productions = Production.playing.paginate(:page => params[:page], :order => order)
    elsif params[:show] == "will_open"
      @productions = Production.will_open.paginate(:page => params[:page], :order => order)
    else
      @productions = Production.paginate(:page => params[:page], :order => order)
    end
  end

  def method_missing(method_id, *arguments)
    if match = /^auto_complete_for_([a-zA-Z]\w*)_([a-zA-Z]\w*)_([a-zA-Z]\w*)/.match(method_id.to_s)
      auto_completer(match[1], match[2], match[3])
    else
      super
    end
  end
  
  private
  def auto_completer(obj, association, method)
    param_value = params[obj.to_sym].send("[]", (association + "_" + method).to_sym)
    re = Regexp.new("^#{param_value}", "i")
    find_options = { :order => method + " ASC" }
    @all_objs = Kernel.const_get(association.singularize.capitalize).send(:all, find_options)
    @collection = @all_objs.collect(&(method.to_sym)).select { |obj| obj.match re }
    render :inline => "<%= content_tag(:ul, @collection.map { |obj| content_tag(:li, h(obj)) }) %>"
  end
end