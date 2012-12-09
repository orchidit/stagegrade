class Admin::ReportsController < Admin::AdminController
  # Super: index, edit, show, create, update, destroy
  # Here:  new

  def index
    respond_to do |format|
      format.html
      format.js { reports_list }
    end
  end

  def show
    @report = Report.find(params[:id])
  end

  def new
    redirect_index
  end

  def review
    @report = Report.find(params[:id])
    @report.reviewed_by = current_user

    respond_to do |format|
      if @report.save
        flash[:notice] = "Report was reviewed."
        format.html { redirect_to(admin_reports_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def unreview
    @report = Report.find(params[:id])
    @report.reviewed_by = nil

    respond_to do |format|
      if @report.save
        flash[:notice] = "Report was unreviewed."
        format.html { redirect_to(admin_reports_path) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  private
  def reports_list
    filters = {
      :new => "reviewed_by_id is null",
      :spam => [ "reviewed_by_id is null and is_spam=?", true ],
      :nonspam => [ "reviewed_by_id is null and is_spam=?", false ],
      :all => ""
    }

    conditions = filters[(params[:show] || :new).to_sym]

    @reports = Report.all(:conditions => conditions, :order => "created_at desc")
    render :partial => "reports_list", :locals => { :reports => @reports }
  end
end