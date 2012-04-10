class Api::MessagesController < ApplicationController
   before_filter :authenticate_user!

   def index
  	 #@messages = Message.all_messages_for_user(current_user.id)
  	 @messages = Message.recent_message_list(current_user.id) 
  	 respond_to do |format|
     format.json{render :json => @messages.map{ |msg| r = msg.recepients.find(msg.recepient_id); {:id => msg.id,
                                                       :sender_first_name => msg.sender.first_name,
              	     																	 :sender_last_name => msg.sender.last_name,
               	     																	 :sender_title => msg.sender.title_name,
	                   																	 :sender_image => msg.sender.mini_photo_url,
                                                       :sender_email => msg.sender_email,
                                                       :attachmenats => msg.attachments.map{|atta|{:url => "#{atta.photo_url}"}},
                                                       :recepients=>[{:recepient_id => msg.recepient_id,
                                                       :recepient_email => r.email,
                                                       :recepient_image => r.mini_photo_url,
                                                       :recepient_first_name => r.first_name,
              	     																	 :recepient_last_name => r.last_name,
               	     																	 :recepient_title => r.title_name}],
               	     																	 :messages_count => msg.messages_count,
                                                       #:recepients => msg.message_recepients.map{|rec|{:recepient_id =>rec.recepient_id,:recepient_email => rec.recepient.email,
                                                       #:deleted => rec.recepient_deleted,:read_at => rec.read_at,:is_readed => rec.read?,:recepient_first_name => rec.recepient.first_name,
                                                       #:recepient_last_name => rec.recepient.last_name,:recepient_title => ((rec.recepient.title.present?)? rec.recepient.title.name : ''),:recepient_image => rec.recepient.mini_photo_url}},
                                                       :body => msg.body,:sender=>msg.sender_id,:expired_at => msg.formatted_expired_at,
                                                       :sender_deleted =>msg.sender_deleted, :expired =>msg.expired,:created_at => msg.formatted_created_at }}}
  	 end
   end

	def messages_between_user
		@messages = Message.messages_between_user(current_user.id,params[:user_id])
	  	 respond_to do |format|
	     format.json { render :json => @messages.map{|msg|{:sender_id => msg.sender_id,
	     																	 :sender_email => msg.sender_email,
	     																	 :sender_first_name => msg.sender_first_name,
	     																	 :sender_last_name => msg.sender_last_name,
	     																	 :sender_title => msg.sender_title,
	     																	 :sender_image => msg.sender.mini_photo_url,
	     																	 :recepient_first_name => msg.recepient_first_name,
	     																	 :recepient_last_name => msg.recepient_last_name,
	     																	 :recepient_title => msg.recepient_title,
	     																	 :recepient_image => User.find_by_id(msg.recepient_id).mini_photo_url, 
	     																	 :id => msg.id, 
	     																	 :recepient_id => msg.recepient_id,
	     																	 :body => msg.body,
	     																	 :recepient_email => msg.recepient_email,
	     																	 :created_at => msg.formatted_created_at,
	     																	 :is_readed => msg.mread_at.present?,
	     																	 :attachments_present => msg.attachment_present?,
	     																	 :attachmenats => msg.attachments.map{|atta|{:url => "#{atta.photo_url}"}},
	     																	 :expired_at => msg.formatted_expired_at}}.to_json}
	   end
	end  
  
  def show
    @message = Message.read(params[:id],current_user)
    respond_to do|format|
      format.json{render :json =>@message.to_json(:methods => [:sender_email,:attachment_urls,:sender_image_file],:include => {:message_recepients=>{:include => {:recepient=>{:only => :email}},:except=>[:message_id,:id]}})}
    end
  end

  def create
=begin
        @message = Message.new(params[:message])
        @message.sender = current_user
        if @message.valid?
          @message.expired_at = DateTime.now + current_user.expire_settings_message.lifespan_hours.to_i.hour if current_user.expire_settings_message.present? && current_user.expire_settings_message.expire_is_set?
    	   if !params[:attachments].blank? && !params[:attachments].nil?
        	 	unless params[:attachments].blank?
        	 		@attachments = (params[:attachments]).split(',')
        	  		@attachment_count = params[:attachments_count]
        	  		i = 1
    	      	@attachments.each do |attachment|
      	      	filename = "test#{Time.now.to_i}"
       					File.open("#{filename}_#{i}.png","wb") do |file|
      						temp2 = ActiveSupport::Base64.decode64(attachment)
      						file.write(temp2)
      						file.close
      		   		end 
      					f = File.open("#{filename}_#{i}.png")
      					itemphoto = @message.attachments.build
      					itemphoto.data = f
      					f.close
      					File.delete("#{filename}_#{i}.png")
      					i = i + 1
    				  end		
    			  end
    		 end	  
    		 if params[:video_attachments].present?
        	 	unless params[:video_attachments].blank?
        	 		@vattachments = (params[:video_attachments]).split(',')
        	  		i = 1
    	      	@vattachments.each do |attachment|
      	      	vfilename = "video#{Time.now.to_i}"
       					File.open("#{vfilename}_#{i}.mpeg","wb") do |file|
      						temp2 = ActiveSupport::Base64.decode64(attachment)
      						file.write(temp2)
      						file.close
      		   		end 
      					f = File.open("#{vfilename}_#{i}.mpeg")
      					itemphoto = @message.attachments.build
      					itemphoto.data = f
      					f.close
      					File.delete("#{vfilename}_#{i}.mpeg")
      					i = i + 1
    				 end		
    			  end
    		 end
         @message.save
         flash[:notice] = "Message sent!"
         respond_to do|format|
          format.json{render :json =>@message.to_json(:methods => [:sender_email,:attachment_urls,:sender_image_file],:include => {:message_recepients=>{:include => {:recepient=>{:only => :email}},:except=>[:message_id,:id]}})}
         end
        else
         flash[:notice] = "Invalid Message" 
          respond_to do |format|
    	      format.json{render :json => {:error => flash[:notice]}.to_json}
          end
        end
=end
      @message = Message.new
      @message.sender = current_user
      @message.body = params[:message_body]
      @message.recepient_tokens = params[:message_recepient_tokens]
      if params[:file].present? 
        @video_attachments = @message.attachments.build
        @video_attachments.data = params[:file]
      end   
     if @message.save
         flash[:notice] = "Message sent!"
         respond_to do|format|
          format.json{render :json =>@message.to_json(:methods => [:sender_email,:attachment_urls,:sender_image_file],:include => {:message_recepients=>{:include => {:recepient=>{:only => :email}},:except=>[:message_id,:id]}})}
         end
     else
       flash[:notice] = "Invalid Message" 
        respond_to do |format|
   	      format.json{render :json => {:error => flash[:notice]}.to_json}
        end
     end 
  end
  
  def destroy
  	@message = Message.find(params[:id])
  	if @message.present?
  		@message.mark_deleted(current_user) 
  		render :json => {:message => "message destroyed successfully!"}.to_json
  	else
  		render :json => {:error => "Message not exist!"}.to_json
  	end
  end

end
