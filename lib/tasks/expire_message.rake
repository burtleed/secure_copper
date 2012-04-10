desc "Destroy Expired Messages."
task :expire_message => :environment do 
  extime = Time.now.strftime("%Y-%m-%d %H:%M:%S")
	@expired_messages = Message.where("expired_at < '#{extime}'")
	puts "------------#{@expired_messages.size}"
	puts "------------#{@expired_messages.collect(&:id).inspect}"
	if @expired_messages.any?
	   Message.transaction do
	   	#delete message recepients.
	   	MessageRecepient.delete_all("message_id in (#{@expired_messages.collect(&:id).join(',')})")
	   	#delete message attachements.
	   	Attachment.delete_all("message_id in (#{@expired_messages.collect(&:id).join(',')})")
	   	#delete all expired messages.
	   	Message.delete_all("id in (#{@expired_messages.collect(&:id).join(',')})")
	   end
	end   
	
	@deleted_messages = Message.where("sender_deleted = true")
	puts "------------#{@deleted_messages.size}"
	puts "------------#{@deleted_messages.collect(&:id).inspect}"
	if @deleted_messages.any?
     Message.transaction do
	   	#delete message recepients.
	   	MessageRecepient.delete_all("message_id in (#{@deleted_messages.collect(&:id).join(',')})")
	   	#delete message attachements.
	   	Attachment.delete_all("message_id in (#{@deleted_messages.collect(&:id).join(',')})")
	   	#delete all expired messages.
	   	Message.delete_all("id in (#{@deleted_messages.collect(&:id).join(',')})")
	   end
	end 
end