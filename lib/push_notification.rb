require "net/http"
require "net/https"
module PushNotification

  def send_push_notification_to_recepients
    @message = Message.find_by_id(self.id)
    if @message.present? && @message.recepients.any?
       @message.recepients.each do |recepient|
        if recepient.has_device_details?
           if recepient.is_android_device?
             begin          
              options = {  							
      		    :registration_id => recepient.device_registration_id,
      		    #"APA91bH-V8Fq_6K3HJSEAuHZIuzQ2cgRhYC4Wm9wajkhf4BoHQ0GW0gfZ2pDfRBRrwavsMrW3vxXLQuPn3VKYi34ZF3-o6kOsF4zQM5-KRbBnz2f_tDP-OQ0mIR_ALMSj6MqlquwAAqVXLfcfSvS60i5sPjQDiHjBA",
        		  :message => "You have one new message!",
        		  :extra_data => nil,
        		  :collapse_key => "myapp"
      	      }
      	      response = SpeedyC2DM::API.send_notification(options)
      	    rescue Exception => e
      	      next
      	    end
      	  elsif recepient.is_iphone_device? 
           #token = recepient.device_registration_id.gsub(/[a-z0-9]{8}/).each{|p| "#{p}\s"}.chop
           token = recepient.device_registration_id.gsub(/[<>]/,'')
           device = APN::Device.find_or_create_by_token(token)
           if device.valid?
             device.save
             #device = APN::Device.find_by_token(token)
             notification = APN::Notification.new 
             notification.device_id = device.id 
             notification.badge = 1 
             notification.sound = true 
             notification.alert = "Secure Copper : You have new message."
             puts "--not--111--#{notification.valid?}----------------------" 
             notification.save
           end  
           #rake apn:notifications:deliver    
      	  end    
        else 
            puts "in else...." 	      
  	    end  
	    end
  	end
   end	
  	
end  	