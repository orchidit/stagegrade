class Admin::AdminController < ApplicationController
  before_filter :require_admin

  def index
    name = controller_name
    klass = Kernel.const_get(name.singularize.camelize)
    if klass.respond_to? :paginate
      instance_variable_set("@" + name, klass.paginate(:page => params[:page]))
    else
      instance_variable_set("@" + name, klass.all)
    end
    instance_variable_set("@" + name.singularize, klass.new)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => instance_variable_get("@" + name) }
    end
  end

  def show
    name = controller_name.singularize.downcase
    klass = Kernel.const_get(name.camelize)
    instance_variable_set("@" + name.downcase.to_s, klass.find(params[:id]))

    respond_to do |format|
      format.html { redirect_index }
      format.js { render :partial => "#{name}_details",
          :locals => { name.to_sym => instance_variable_get("@" + name) } }
    end
  end

  def new
    name = controller_name.singularize
    instance_variable_set("@" + name, Kernel.const_get(name.camelize).new)
  end

  def edit
    name = controller_name.singularize
    instance_variable_set("@" + name, Kernel.const_get(name.camelize).find(params[:id]))
  end

  def create(redirect = nil)
    redirect = admin_index_path if redirect.nil?

    name = controller_name.singularize
    instance_variable_set("@" + name, Kernel.const_get(name.camelize).new(params[name.to_sym]))
    ivar = instance_variable_get("@" + name)

    respond_to do |format|
      if ivar.save
        flash[:notice] = "#{name.humanize.capitalize} was successfully created."
        format.html { redirect_to(redirect) }
        format.xml  { render :xml => ivar, :status => :created, :location => ivar }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => ivar.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update(redirect = nil)
    redirect = admin_index_path if redirect.nil?

    name = controller_name.singularize
    klass = name.camelize
    instance_variable_set("@" + name, Kernel.const_get(klass).find(params[:id]))
    ivar = instance_variable_get("@" + name)

    # Need to re-get the klass since it might not match the controller name (e.g., for STI).
    original_verbosity = $VERBOSE
    $VERBOSE = nil
    klass = ivar.type.to_s
    $VERBOSE = original_verbosity

    respond_to do |format|
      if ivar.update_attributes(params[klass.underscore.to_sym])
        flash[:notice] = "#{klass.underscore.humanize.titleize} was successfully updated."
        format.html { redirect_to(redirect) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => ivar.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    model_name = controller_name.singularize
    @obj = model_name.camelize.constantize.find(params[:id])
    @obj.destroy

    respond_to do |format|
      format.html { redirect_to(send("admin_" + model_name.pluralize + "_path")) }
      format.xml  { head :ok }
    end
  end

  def method_missing(method_id, *arguments)
    match = /^auto_complete_for_review_(production|review|play|critic|publication|theatre)_([a-zA-Z_]\w*)/.match(method_id.to_s)
    if !match.nil?
      auto_completer(match[1], match[2])
    else
      super
    end
  end

  private
  def redirect_index
    redirect_to :action => "index"
  end

  def auto_completer(association, method)
    param_value = params[:review].send("[]", (association + "_" + method).to_sym)
    re = Regexp.new("^#{param_value}", "i")
    @all_objs = Kernel.const_get(association.singularize.capitalize).all
    @collection = @all_objs.collect(&(method.to_sym)).select { |obj| !obj.nil? and obj.match(re) }.sort
    render :inline => "<%= content_tag(:ul, @collection.map { |obj| content_tag(:li, h(obj)) }) %>"
  end
end