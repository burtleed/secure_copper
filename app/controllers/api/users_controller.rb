class Api::UsersController < ApplicationController
	before_filter :authenticate_user!

	def index
	  @users = User.contact_list(current_user,["#{current_user.id}"])
	  response_parameters(@users)
	end
	
	def search
	  @users = User.contact_list(current_user,["#{current_user.id}"]).where("email like '%#{params[:q]}%'")
	  response_parameters(@users)
	end
	
	def update_data
    @users = current_user
    #@users.first_name = params[:user][:first_name] if params[:user][:first_name].present?
    #@users.last_name = params[:user][:last_name] if params[:user][:last_name].present?
    #@users.username = params[:user][:username] if params[:user][:username].present? 
    @users.device_type = params[:user][:device_type] if params[:user][:device_type].present?
    @users.device_registration_id = params[:user][:device_registration_id] if params[:user][:device_registration_id].present?
    if @users.save
     logger.warn("----d_reg_id:--#{@user.id}-:-#{@users.device_registration_id}----------------")
     respond_to do|format|
       format.json { render :json => @users.to_json(:except => [:encrypted_password,:parent_id,:created_at,
   	              :updated_at,:sign_in_count,:current_sign_in_at,:last_sign_in_at,:current_sign_in_ip,
   								:last_sign_in_ip,:user_creation_limit,:photo_file_name,:photo_content_type,:photo_file_size,
   							  :photo_updated_at],:methods => [:group_name,:role_name,:userid,:mini_photo_url,:title_name])
        }
     end 
    else
      respond_to do |format|
        format.json { render :json => @users.errors.full_messages.to_json }
      end
    end
	end 

   private

   def response_parameters(users)
     respond_to do|format|
       format.json { render :json => @users.to_json(:except => [:encrypted_password,:parent_id,:created_at,
     	              :updated_at,:sign_in_count,:current_sign_in_at,:last_sign_in_at,:current_sign_in_ip,
     								:last_sign_in_ip,:user_creation_limit,:photo_file_name,:photo_content_type,:photo_file_size,
     							  :photo_updated_at],:methods => [:group_name,:role_name,:userid,:mini_photo_url,:title_name])
      }
    end 
   end
end