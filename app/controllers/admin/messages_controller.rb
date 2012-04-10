class Admin::MessagesController < ApplicationController
  before_filter :check_valid_user

  def index
    @users_list = current_user.contact_list(current_user)
    @recepient_id = ""
  end

  def new
  	 @message = Message.new
  end  
  
  def create
    @users_list = current_user.contact_list(current_user)
    @message = Message.new()
    @message.body = params[:message][:body]
    @message.sender_id = current_user.id 
    @message.recepient_ids = params[:message][:recepient_ids].to_s.split(',')
    @message.expired_at = DateTime.now + current_user.expire_settings_message.lifespan_hours.to_i.hour if current_user.expire_settings_message.present? && current_user.expire_settings_message.expire_is_set?
    current_user.temp_file_uploads.find(:all,:conditions=>["keyname = ? and user_id=?",session[:session_id],current_user.id]).each{|tfile| 
     	@fileupload = Attachment.new
     	@fileupload.data = tfile.data
     	@message.attachments << @fileupload  if !@fileupload.data_file_name.nil? && @fileupload.save
    }
    logger.warn("---#{@message.valid?}---#{@message.errors.full_messages.inspect}-------------------------")  
    respond_to do |format|
      if @message.save
        flash[:notice] = "Message successfully created"
        TempFileUpload.destroy_all(:user_id => current_user.id,:keyname => session[:session_id])
        if params[:save_method] == "apply"
         format.html { redirect_to admin_messages_url, :layout => !request.xhr? }
         format.js 
        elsif params[:save_method] == "apply_new"
         format.html { redirect_to new_admin_message_url, :layout => !request.xhr? }
        else
	    	@recepient_id = @message.recepient_ids.first
  			@recepient = User.find(@recepient_id) if @recepient_id.present?
         format.html { redirect_to admin_messages_url, :layout => !request.xhr? }
         format.js 
        end
      else
        if params[:save_method] == "apply" || params[:save_method] == "apply_new" 
        		format.html { render :action => "new", :layout => !request.xhr? }
        		format.js
        else
        		format.html { render :action => "index", :layout => !request.xhr? }
        		format.js
        end		 
      end
     end
  end
  
  def list
    @recepient_id = params[:id].to_i
    #@messages = current_user.all_messages_for_user(@recepient_id)
    @messages = Message.messages_between_user(current_user.id,@recepient_id)
    @recepient = User.find(@recepient_id)
    respond_to do |format|
      format.html { render :partial=>"/admin/messages/message_list_by_user", :locals=>{:recepient_id => @recepient_id,:recepient => @recepient}}
      format.pdf { 
        pdf = MessageDocument.new(@messages,current_user,@recepient)
        send_data pdf.render, :filename => "message_between_#{current_user.first_name}_and_#{@recepient.first_name}.pdf",:type => "application/pdf",:disposition => "inline"      
      }
    end  
  end

  def search_contact
    if !params[:first_name].blank?
       @users_list = User.contact_list(current_user,["#{current_user.id}"]).where("first_name regexp '^#{params[:first_name]}'")
    else
       @users_list = User.contact_list(current_user,["#{current_user.id}"])
    end	
  end

  def set_recepients
    if request.get?
      @users_list = current_user.contact_list(current_user)
      render :layout => false 
    else
  	 	@recepients = User.find_all_by_id(params[:cid])
  	 end	
  end
  
  def delete_selected
    if request.post?
      if params[:delete]
        params[:delete].each { |id|
          @message = Message.find_by_id(id)
          @message.mark_deleted(current_user) unless @message.nil?
        }
        flash[:notice] = "Messages deleted"
      end
      redirect_to admin_messages_path
    end
  end

  def show_attachments
  	 @message = Message.find(params[:id])
  	 @attachments = @message.attachments
  	 respond_to do |format|
  	 	format.js
  	 	format.html {render :partial => "show_attachments", :object => @attachments}
  	 end
  end

  def send_attachemnt_file
    @attchment = Attachment.find(params[:id])
    if @attchment.message.sender_id == current_user.id || @attchment.message.recepients.include?(current_user) 
  	 	send_file "#{@attchment.data.path}", :type => "#{@attchment.data_content_type}"
  	else
  	 	render :text => "You are not allowed to access this file.",:layout => "application"	
  	end
  end
  
  def destroy
	  @message = Message.find(params[:id])
	  if @message.present?
    	@message.mark_deleted(current_user)
    end
    respond_to do |format|
    	format.js 
    	format.html { redirect_to admin_messages_path }
    end 	
  end
   
  private
  def check_valid_user
    if !user_signed_in?
      flash[:error] = "You are not permitted, you have to log with user admin"
      redirect_to root_path
    end
  end
end