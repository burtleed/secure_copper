class Admin::GroupsController < ApplicationController
  before_filter :check_valid_user
  before_filter :set_page_and_per_page, :only => [:index]
  # GET /admin/groups
  # GET /admin/groups.xml
  def index
    @search_text = session[:search_groups]
    (@search_text.blank?)?(@search_text=''):(@search_text='%'+@search_text+'%')
    if current_user.is_super_admin?
      @admin_groups = Admin::Group.search_filter(@search_text).paginate(:per_page => @per_page,:page => @page,:order=>"name asc", :include => [:hospital])
    else
      @admin_groups = Admin::Group.search_filter(@search_text).paginate(:per_page => @per_page,:page => @page,:order=>"name asc", :include => [:hospital],:conditions=>["hospital_id = ?", current_user.hospital_id])
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_groups }
    end
  end

  # GET /admin/groups/new
  # GET /admin/groups/new.xml
  def new
    @admin_group = Admin::Group.new
	 @users1 =  []
	 @users2 = []
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin_group }
    end
  end

  # GET /admin/groups/1/edit
  def edit
    @admin_group = Admin::Group.find(params[:id])
    @users1 = (@admin_group.hospital.present?)? (@admin_group.hospital.users - @admin_group.users).map{|m| "'#{m.id},#{m.name}'"}.join(',') : []
    @users2 = @admin_group.users.map{|m| "'#{m.id},#{m.name}'"}.join(',')
    unless current_user.is_super_admin?
      unless current_user.hospital_id.to_s ==  @admin_group.hospital_id.to_s
        flash[:error] = "You are not permitted, you have to log with user admin"
        redirect_to root_path
      end
    end
  end

  # POST /admin/groups
  # POST /admin/groups.xml
  def create
    @admin_group = Admin::Group.new(params[:admin_group])
    @users1 = (@admin_group.hospital.present?)? (@admin_group.hospital.users - @admin_group.users).map{|m| "'#{m.id},#{m.name}'"}.join(',') : []
    @users2 = @admin_group.users.map{|m| "'#{m.id},#{m.name}'"}.join(',')
    respond_to do |format|
      if @admin_group.save
        if params[:save_method] == "apply"
          format.html { redirect_to(admin_groups_url, :notice => 'Group was successfully created.') }
          format.xml  { render :xml => @admin_group, :status => :created, :location => @admin_group }
        else
          format.html { redirect_to(new_admin_group_url, :notice => 'Group was successfully created.') }
          format.xml  { render :xml => @admin_group, :status => :created, :location => @admin_group }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin_group.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/groups/1
  # PUT /admin/groups/1.xml
  def update
    @admin_group = Admin::Group.find(params[:id])
    @users1 = (@admin_group.hospital.present?)? (@admin_group.hospital.users - @admin_group.users).map{|m| "'#{m.id},#{m.name}'"}.join(',') : []
    @users2 = @admin_group.users.map{|m| "'#{m.id},#{m.name}'"}.join(',')
    respond_to do |format|
      if @admin_group.update_attributes(params[:admin_group])
        if params[:save_method] == "apply"
          format.html { redirect_to(admin_groups_url, :notice => 'Group was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { redirect_to(new_admin_group_url, :notice => 'Group was successfully created.') }
          format.xml  { render :xml => @admin_group, :status => :created, :location => @admin_group }
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin_group.errors, :status => :unprocessable_entity }
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
        @group = Admin::Group.find(@id)
        redirect_to(edit_admin_group_url(@group.to_param))
      else
        flash[:error] = 'You have not selected any record. Please try again.'
        redirect_to(admin_groups_url)
      end
    elsif @source == 'delete'
      if cid
        Admin::Group.destroy_all(['id in (?)',cid])
        redirect_to(admin_groups_url)
      else
        flash[:error] = 'You have not selected any record. Please try again.'
        redirect_to(admin_groups_url)
      end
    elsif @source == 'go'
      session[:search_groups] = params[:filter_search]
      redirect_to(admin_groups_url)
    elsif @source == 'reset'
      session[:search_groups] = nil
      redirect_to(admin_groups_url)
    else
      redirect_to(admin_groups_url)
    end
  end
  
  
  def add_users
	if !params[:hospital_id].blank?
	  	@hospital = Admin::Hospital.find(params[:hospital_id])
    	@users1 = @hospital.users
    	@users2 = []
    else
    	@users1 = []
    	@users2 = []
    end	
  end
 
  private
  def check_valid_user
    if !user_signed_in? || (user_signed_in? && !current_user.is_super_admin? && !current_user.is_hospital_admin?)
      flash[:error] = "You are not permitted, you have to log with user admin"
      redirect_to root_path
    end
  end
end
