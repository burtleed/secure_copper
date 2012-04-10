class Admin::TitlesController < ApplicationController
  before_filter :check_valid_user
  before_filter :set_page_and_per_page, :only => [:index]
  # GET /admin/titles
  # GET /admin/titles.xml
  def index
    @search_text = session[:search_titles]
    (@search_text.blank?)?(@search_text=''):(@search_text='%'+@search_text+'%')
    if current_user.is_super_admin?
      @admin_titles = Admin::Title.search_filter(@search_text).paginate(:per_page => @per_page,:page => @page,:order=>"name asc", :include => [:hospital])
    else
      @admin_titles = Admin::Title.search_filter(@search_text).paginate(:per_page => @per_page,:page => @page,:order=>"name asc",:conditions=>["hospital_id = ?", current_user.hospital_id],:include => [:hospital])
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_titles }
    end
  end

  # GET /admin/titles/new
  # GET /admin/titles/new.xml
  def new
    @admin_title = Admin::Title.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin_title }
    end
  end

  # GET /admin/titles/1/edit
  def edit
    @admin_title = Admin::Title.find(params[:id])
    unless current_user.is_super_admin?
      unless current_user.hospital_id.to_s ==  @admin_title.hospital_id.to_s
        flash[:error] = "You are not permitted, you have to log with user admin"
        redirect_to root_path
      end
    end
  end

  # POST /admin/titles
  # POST /admin/titles.xml
  def create
    @admin_title = Admin::Title.new(params[:admin_title])

    respond_to do |format|
      if @admin_title.save
        if params[:save_method] == "apply"
          format.html { redirect_to(admin_titles_url, :notice => 'Title was successfully created.') }
          format.xml  { render :xml => @admin_title, :status => :created, :location => @admin_title }
        else
          format.html { redirect_to(new_admin_title_url, :notice => 'Title was successfully created.') }
          format.xml  { render :xml => @admin_title, :status => :created, :location => @admin_title }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin_title.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/titles/1
  # PUT /admin/titles/1.xml
  def update
    @admin_title = Admin::Title.find(params[:id])

    respond_to do |format|
      if @admin_title.update_attributes(params[:admin_title])
        if params[:save_method] == "apply"
          format.html { redirect_to(admin_titles_url, :notice => 'Title was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { redirect_to(new_admin_title_url, :notice => 'Title was successfully created.') }
          format.xml  { render :xml => @admin_title, :status => :created, :location => @admin_title }
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin_title.errors, :status => :unprocessable_entity }
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
        @title = Admin::Title.find(@id)
        redirect_to(edit_admin_title_url(@title.to_param))
      else
        flash[:error] = 'You have not selected any record. Please try again.'
        redirect_to(admin_titles_url)
      end
    elsif @source == 'delete'
      if cid
        Admin::Title.destroy_all(['id in (?)',cid])
        redirect_to(admin_titles_url)
      else
        flash[:error] = 'You have not selected any record. Please try again.'
        redirect_to(admin_titles_url)
      end
    elsif @source == 'go'
      session[:search_titles] = params[:filter_search]
      redirect_to(admin_titles_url)
    elsif @source == 'reset'
      session[:search_titles] = nil
      redirect_to(admin_titles_url)
    else
      redirect_to(admin_titles_url)
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
