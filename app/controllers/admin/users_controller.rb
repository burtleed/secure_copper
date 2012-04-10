class Admin::UsersController < ApplicationController
  before_filter :check_valid_user
  before_filter :set_page_and_per_page, :only => [:index]
  
  # GET /admin/users
  # GET /admin/users.xml
  def index
    @search_text = session[:search_users]
    (@search_text.blank?)?(@search_text=''):(@search_text='%'+@search_text+'%')
    if current_user.is_super_admin?
      @users = User.search_filter(@search_text).paginate(:page => @page,:per_page => @per_page,:order => "id asc")
    elsif current_user.is_hospital_admin?
      @users = User.search_filter(@search_text).paginate(:page => @page,:per_page => @per_page,:order=>"id asc", :conditions=>["hospital_id = ?", current_user.hospital_id])
    else
      @users = [current_user]
    end
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @users }
    end
  end

  # GET /admin/users/new
  # GET /admin/users/new.xml
  def new
    @user = User.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /admin/users/1/edit
  def edit
    @user = User.find(params[:id])
    unless current_user.is_super_admin?
      unless current_user.hospital_id.to_s ==  @user.hospital_id.to_s
        flash[:error] = "You are not permitted, you have to log with user admin"
        redirect_to root_path
      end
    end
  end

  # POST /admin/users
  # POST /admin/users.xml
  def create
    @user = User.new(params[:user])
    @user.deny_member_ids = params[:user][:deny_member_ids] if params[:user][:deny_member_ids].present? 
    respond_to do |format|
      if @user.save 
        #send mail notification to user.
        Mailer::Notifier.send_password_to_user(@user,params[:user][:password]).deliver
        if params[:user][:deny_member_ids].present?
        	 @deny_mem = @user.memberships.find_all_by_member_id(params[:user][:deny_member_ids])
        	 @deny_mem.each do |member|
        	 	member.update_attribute("allowed",false)
        	 end	
        end	 
        if params[:save_method] == "apply"
          format.html { redirect_to(admin_users_url, :notice => 'User was successfully created.') }
          format.xml  { render :xml => @user, :status => :created, :location => @user }
        else
          format.html { redirect_to(new_admin_user_url, :notice => 'User was successfully created.') }
          format.xml  { render :xml => @user, :status => :created, :location => @user }
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin/users/1
  # PUT /admin/users/1.xml
  def update
    @user = User.find(params[:id])
    if !params[:user][:allowed_member_ids].present?
    	@user.allowed_member_ids = []
	 end
    if !params[:user][:deny_member_ids].present?
    	@user.deny_member_ids = []
	 end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        if params[:user][:deny_member_ids].present?
        	 @deny_mem = @user.memberships.find_all_by_member_id(params[:user][:deny_member_ids])
        	 @deny_mem.each do |member|
        	 	member.update_attribute("allowed",false)
        	 end	
        end
        if params[:save_method] == "apply"
          format.html { redirect_to(admin_users_url, :notice => 'User was successfully updated.') }
          format.xml  { head :ok }
        else
          format.html { redirect_to(new_admin_user_url, :notice => 'User was successfully created.') }
          format.xml  { render :xml => @user, :status => :created, :location => @user }
        end
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
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
        @user = User.find(@id)
        redirect_to(edit_admin_user_url(@user.to_param))
      else
        flash[:error] = 'You have not selected any record. Please try again.'
        redirect_to(admin_users_url)
      end
    elsif @source == 'delete'
      if cid
        User.destroy_all(['id in (?)',cid])
        redirect_to(admin_users_url)
      else
        flash[:error] = 'You have not selected any record. Please try again.'
        redirect_to(admin_users_url)
      end
    elsif @source == 'go'
      session[:search_users] = params[:filter_search]
      redirect_to(admin_users_url)
    elsif @source == 'reset'
      session[:search_users] = nil
      redirect_to(admin_users_url)
    elsif @source == 'activate'
    	cid = "#{cid.join(',')}" if cid.size > 1
    	@users = User.where("id in (#{cid})")
    	@users.each do |user|
			  user.update_attribute("status",1) 
    	end 
    	#User.update_all("status = 1","id in (#{cid})")
      if params[:page] == "1"
      	redirect_to(admin_users_url)
      else	
      	redirect_to(admin_users_url(:page => "#{params[:page]}"))
      end	
    elsif @source == 'block'
    	cid = "#{cid.join(',')}" if cid.size > 1
		  @users = User.where("id in (#{cid})")
   	  @users.each do |user|
    		user.update_attribute("status",0) if !user.is_any_admin? && user.id != current_user.id
    		if current_user.is_super_admin? && user.is_hospital_admin? 
    		  User.update_all("status = 0","hospital_id = #{user.hospital_id}")  
    		end
    	end 
      #User.update_all("status = 0","id in (#{cid})")
      if params[:page] == "1"
      	redirect_to(admin_users_url)
      else	
      	redirect_to(admin_users_url(:page => "#{params[:page]}"))
      end	
    else
      redirect_to(admin_users_url)
    end
  end
  
  def change_password
  		if request.get?
			@user = current_user  			
  		else
			@user = current_user  	
			if @user.update_with_password(params[:user])
				sign_in(@user, :bypass => true)
  				flash[:notice] = "Your password is changed successfully."
			else
  					
			end	
  		end
  end
  
  def user_list
    if request.get?
      hospital_id = params[:user][:hospital_id]
     	user_id = params[:user_id].present? ? params[:user_id] : ""
     	if hospital_id.present?
       	@groups = (!params[:user][:group_ids].present?)? "no-grp" : ((params[:user][:group_ids].size == 1 && params[:user][:group_ids].first == "")? "all_grp" : params[:user][:group_ids].join(','))
     		allowed_ids = params[:user][:allowed_member_ids].present? ? params[:user][:allowed_member_ids].join(',') : ""
	  	  deny_ids = (params[:user][:deny_member_ids].present?)? params[:user][:deny_member_ids].join(',') : ""
	     	if params[:act] == "allow_add"
	     		@users = allowed_user_list(@groups,user_id,hospital_id,allowed_ids)
	     	elsif params[:act] == "allow_remove"
	     		@users = get_users(allowed_ids)	
		  	elsif params[:act] == "deny_add"
		  	  @users =  deny_user_list(@groups,user_id,hospital_id,deny_ids)
		    elsif params[:act] == "deny_remove"
		      @users = get_users(deny_ids)
	    	end
				render :partial => "user_list", :locals => {:users => @users, :act => params[:act]}  
	    else
  	   	render :text => "You have to select hospital first."
	    end	
    else
      @act = params[:act]
     	@cid = params[:cid].join(",")
     	if params[:act] == "allow_add" || params[:act] == "deny_add"
     		@users = User.find(params[:cid])
     	elsif params[:act] == "allow_remove" || params[:act] == "deny_remove"
 				@cid = @cid.split(',')  					     		
    	end
   	  respond_to do |format|
   	   	format.js
   	  end 
   	end
  end

  private
  
  def check_valid_user
    if !user_signed_in?
      flash[:error] = "You are not permitted, you have to log with valid user"
      redirect_to root_path
    end
  end
  
  def allowed_user_list(groups,user_id,hospital_id,allowed_ids)
    except = merge_except_user(user_id,allowed_ids)
    if groups == "all_grp"
      @users = []
    elsif groups == "no-grp"
      @users =  User.active_hospital_users(hospital_id,except.split(','))
    else
		  @users = User.get_group_users(hospital_id,groups,except)
 		end
  end
  
  def deny_user_list(groups,user_id,hospital_id,deny_ids)
     except = merge_except_user(user_id,deny_ids)
 		 if groups == "all_grp"
 		   @users = User.active_hospital_users(hospital_id,except.split(','))
     elsif groups == "no-grp"
     	 @users = []
     else
		   @users = User.get_users_for_groups(groups,except)
		 end
  end

  def merge_except_user(user_id,member_ids)
     except = user_id 
     if except.blank?
       except = except + member_ids
     else
       except = except + "," + member_ids
     end     
  end
  
  def get_users(member_ids)
      if !member_ids.blank?
		    @users = User.find_all_by_id(member_ids.split(','))
		  else
		   	@users = []
		  end
  end   				
end
