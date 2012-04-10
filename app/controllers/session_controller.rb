class SessionController < Devise::SessionsController

	def create
		if warden.authenticate?(:scope => resource_name)
			resource = warden.authenticate!(:scope => resource_name, :recall => "new")
			if resource.active?
	  			set_flash_message :notice, :signed_in
	  			sign_in(resource_name, resource)
	      	respond_to do|format|
		    		if resource.is_any_admin?
		    		 format.html{redirect_to  admin_users_path}
		          format.json{render :json => resource.to_json(:methods => [:mini_photo_url])}
		    		else
		          flash[:notice] = "Welcome to Secure Copper"
		          format.json{render :json => resource.to_json}
		    		 format.html{redirect_to admin_messages_path}
		    		end
	      	end
	      else
	      	flash[:error] = "Your account has been disabled by admin."
	      	sign_out(current_user)
	      	respond_to do |format|
	      	  format.html {redirect_to new_user_session_path}
	      	  format.json { render :json => {:error => "Your account has been disabled by admin!"}}
	      	end  
	      end	
    else
  		flash[:error] = "Invalid Email or Password"  
      respond_to do|format|  
		    format.html{redirect_to new_user_session_path}
        format.json{render :json => {:error => flash[:notice]}.to_json}
      end
    end	
	end
	
	def destroy
	   unless request.format.json?
			super
		else
			if current_user
				sign_out(current_user)
			end
			respond_to do |format|
				format.json { render :json => {:message => "successfully logout."}}
			end
		end	
	end
end
