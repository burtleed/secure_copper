class Admin::HospitalsController < ApplicationController
  before_filter :check_valid_user
  before_filter :set_page_and_per_page, :only => [:index]
  # GET /admin/hospitals
  # GET /admin/hospitals.xml
  def index
    if current_user.is_super_admin?
      @search_text = session[:search_hospitals]
      (@search_text.blank?)?(@search_text=''):(@search_text='%'+@search_text+'%')
      @admin_hospitals = Admin::Hospital.search_filter(@search_text).paginate(:per_page => @per_page,:page => @page, :order=>"name asc")
    else
      @admin_hospitals = [current_user.hospital]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_hospitals }
    end
  end

  # GET /admin/hospitals/new
  # GET /admin/hospitals/new.xml
  def new
    if current_user.is_super_admin?
      @admin_hospital = Admin::Hospital.new

      respond_to do |format|
        format.html # new.html.erb
        format.xml  { render :xml => @admin_hospital }
      end
    else
      flash[:error] = "You are not permitted, you have to log with user admin"
      redirect_to root_path
    end
  end

  # GET /admin/hospitals/1/edit
  def edit
    if current_user.is_super_admin?
      @admin_hospital = Admin::Hospital.find(params[:id])
    else
      unless current_user.hospital.to_param ==  params[:id]
        flash[:error] = "You are not permitted, you have to log with user admin"
        redirect_to root_path
      else
        @admin_hospital = Admin::Hospital.find(params[:id])
      end
    end
  end

  # POST /admin/hospitals
  # POST /admin/hospitals.xml
  def create
    @admin_hospital = Admin::Hospital.new(params[:admin_hospital])

    respond_to do |format|
      if @admin_hospital.save
        if params[:save_method] == "apply"
          format.html { redirect_to(admin_hospitals_url, :notice => 'Hospital was successfully created.') }
          format.xml  { render :xml => @admin_hospital, :status => :created, :location => @admin_hospital }
        else
          format.html { redirect_to(new_admin_hospital_url, :notice => 'Hospital was successfully created.') }
          format.xml  { render :xml => @admin_hospital, :status => :created, :location => @admin_hospital }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin_hospital.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/hospitals/1
  # PUT /admin/hospitals/1.xml
  def update
    @admin_hospital = Admin::Hospital.find(params[:id])

    respond_to do |format|
      if @admin_hospital.update_attributes(params[:admin_hospital])
        if params[:save_method] == "apply"
          format.html { redirect_to(admin_hospitals_url, :notice => 'Hospital was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { redirect_to(new_admin_hospital_url, :notice => 'Hospital was successfully created.') }
          format.xml  { render :xml => @admin_hospital, :status => :created, :location => @admin_hospital }
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin_hospital.errors, :status => :unprocessable_entity }
      end
    end
  end

  def allinone
    @source=params[:source]
    cid = []
    cid=params[:cid]
#    session[:limit_coupons]=params[:limit]
    if @source == 'edit'
      if cid
        @id=cid.first
        @hospital = Admin::Hospital.find(@id)
        redirect_to(edit_admin_hospital_url(@hospital.to_param))
      else
        flash[:error] = 'You have not selected any record. Please try again.'
        redirect_to(admin_hospitals_url)
      end
    elsif @source == 'delete'
      if cid
        Admin::Hospital.destroy_all(['id in (?)',cid])
        redirect_to(admin_hospitals_url)
      else
        flash[:error] = 'You have not selected any record. Please try again.'
        redirect_to(admin_hospitals_url)
      end
    elsif @source == 'go'
      session[:search_hospitals] = params[:filter_search]
      redirect_to(admin_hospitals_url)
    elsif @source == 'reset'
      session[:search_hospitals] = nil
      redirect_to(admin_hospitals_url)
    else
      redirect_to(admin_hospitals_url)
    end
  end
  
  def change_hospital
    @hospital_id = params[:id]
    @user = User.new
    render :partial=>"/admin/users/admin_only", :locals=>{:disabled=>false, :hospital_id=>@hospital_id}
  end
  
  private
  def check_valid_user
    if !user_signed_in? || (user_signed_in? && !current_user.is_super_admin? && !current_user.is_hospital_admin?)
      flash[:error] = "You are not permitted, you have to log with user admin"
      redirect_to root_path
    end
  end

end