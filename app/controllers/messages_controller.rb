class MessagesController < ApplicationController
  
  before_filter :authenticate_user!
  
  def index
    unless request.format.json?
	    if params[:mailbox] == "sent"
	      @messages = current_user.sent_messages
	    elsif params[:mailbox] == "readed"
	      @messages = Message.read_messages(current_user.id)
	    else
	      @messages = Message.user_messages(current_user.id) 
	    end
	    logger.warn("json response = #{@messages.map{ |msg| {:id => msg.id,:sender_email => msg.sender_email,  :recepients => msg.message_recepients.map{|rec|{:recepient_id =>rec.recepient_id,:recepient_email => rec.recepient.email,:deleted => rec.recepient_deleted,:read_at => rec.read_at,:is_readed => rec.read?}},:body => msg.body,:sender=>msg.sender_id,:expired_at => msg.expired_at,:sender_deleted =>msg.sender_deleted, :expired =>msg.expired,:created_at => msg.created_at }.to_json}}}")
	    respond_to do|format|
	      format.html
	      format.json{render :json => @messages.map{ |msg| {:id => msg.id,
	                                                        :sender_email => msg.sender_email,
	                                                        :attachmenats =>msg.attachments.map{|atta|{:url => "#{atta.photo_url}"}}, 
	                                                        :recepients => msg.message_recepients.map{|rec|{:recepient_id =>rec.recepient_id,:recepient_email => rec.recepient.email,
	                                                            :deleted => rec.recepient_deleted,:read_at => rec.read_at,:is_readed => rec.read?}},
	                                                        :body => msg.body,:sender=>msg.sender_id,:expired_at => msg.expired_at,
	                                                        :sender_deleted =>msg.sender_deleted, :expired =>msg.expired,:created_at => msg.created_at }}}
	    end
	  else
	  	 @messages = Message.all_messages_for_user(current_user.id)
	  	 respond_to do |format|
	     format.json{render :json => @messages.map{ |msg| {:id => msg.id,
	                                                        :sender_email => msg.sender_email,
	                                                        :attachmenats =>msg.attachments.map{|atta|{:url => "#{atta.photo_url}"}}, 
	                                                        :recepients => msg.message_recepients.map{|rec|{:recepient_id =>rec.recepient_id,:recepient_email => rec.recepient.email,
	                                                            :deleted => rec.recepient_deleted,:read_at => rec.read_at,:is_readed => rec.read?}},
	                                                        :body => msg.body,:sender=>msg.sender_id,:expired_at => msg.expired_at,
	                                                        :sender_deleted =>msg.sender_deleted, :expired =>msg.expired,:created_at => msg.created_at }}}
	  	 end
	  end  
  end

	def messages_between_user
		@messages = Message.messages_between_user(current_user.id,params[:user_id])
	  	 respond_to do |format|
	     #format.json{render :json => @messages.map{ |msg| {:id => msg.id,
	     #                                                   :sender_email => msg.sender_email,
	     #                                                   :attachmenats =>msg.attachments.map{|atta|{:url => "#{atta.photo_url}"}}, 
	     #                                                   :recepients => msg.message_recepients.map{|rec|{:recepient_id =>rec.recepient_id,:recepient_email => rec.recepient.email,
	     #                                                       :deleted => rec.recepient_deleted,:read_at => rec.read_at,:is_readed => rec.read?}},
	     #                                                   :body => msg.body,:sender=>msg.sender_id,:expired_at => msg.expired_at,
	     #                                                   :sender_deleted =>msg.sender_deleted, :expired =>msg.expired,:created_at => msg.created_at }}}
	     format.json { render :json => @messages.map{|msg|{:sender_id => msg.sender_id,
	     																	 :sender_email => msg.sender_email,
	     																	 :id => msg.id, 
	     																	 :recepient_id => msg.recepient_id,
	     																	 :body => msg.body,
	     																	 :recepient_email => msg.recepient_email,
	     																	 :created_at => msg.created_at,
	     																	 :is_readed => msg.mread_at.present?,
	     																	 :expired_at => msg.expired_at}}.to_json}
	   end
	end  
  
  def show
    @message = Message.read(params[:id],current_user)
    respond_to do|format|
      format.html
      format.json{render :json =>@message.to_json(:methods => [:sender_email,:attachment_urls],:include => {:message_recepients=>{:include => {:recepient=>{:only => :email}},:except=>[:message_id,:id]}})}
    end
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])
    @message.sender = current_user
    if @message.valid?
      @message.expired_at = DateTime.now + current_user.expire_settings_message.lifespan_hours.to_i.hour if current_user.expire_settings_message.present? && current_user.expire_settings_message.expire_is_set?
      if request.format.html?
      	current_user.temp_file_uploads(:all,:conditions=>["keyname = ?",session[:session_id]]).each{|tfile| 
        	@fileupload = Attachment.new
        	@fileupload.data = tfile.data
        	@message.attachments << @fileupload  if !@fileupload.data_file_name.nil? && @fileupload.save
      	}
      else
	      if !params[:attachments].blank? && !params[:attachments].nil?
    	   	unless params[:attachments].blank?
    	   		@attachments = (params[:attachments]).split(',')
    	   		@attachment_count = params[:attachments_count]
    	    		i = 1
	    	   	@attachments.each do |attachment|
 						File.open("test#{i}.png","wb") do |file|
							temp2 = ActiveSupport::Base64.decode64(attachment)
							file.write(temp2)
							file.close
			   		end 
						f = File.open("test#{i}.png")
						itemphoto = @message.attachments.build
						itemphoto.data = f
						f.close
						File.delete("test#{i}.png")
						i = i + 1
					end		
				end
			end
      end		
      @message.save
      flash[:notice] = "Message sent!"
      TempFileUpload.destroy_all(:user_id => current_user.id,:keyname => session[:session_id])
    respond_to do|format|
     	format.html{ redirect_to messages_url}
      format.json{render :json =>@message.to_json(:methods => [:sender_email,:attachment_urls],:include => {:message_recepients=>{:include => {:recepient=>{:only => :email}},:except=>[:message_id,:id]}})}
    end
    else
     flash[:notice] = "Invalid Message" 
      respond_to do |format|
	      format.html {render :action => "new"}
	      format.json{render :json => {:error => flash[:notice]}.to_json}
      end
    end
  end
  
  def delete_selected
    if request.post?
      if params[:delete]
        params[:delete].each { |id|
          @message = Message.find_by_id(id)#(:first, :conditions => ["messages.id = ? AND (sender_id = ? OR recipient_id = ?)", id, current_user, current_user])
          @message.mark_deleted(current_user) unless @message.nil?
        }
        flash[:notice] = "Messages deleted"
      end
      redirect_to messages_path
    end
  end
  
end
 