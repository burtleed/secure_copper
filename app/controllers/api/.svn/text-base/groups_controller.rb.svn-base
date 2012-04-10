class Api::GroupsController < ApplicationController
	before_filter :authenticate_user!

	def index 
	  @groups = current_user.groups
	  render :json => @groups.to_json(:only => [:id,:name])	
	end
	
   def group_users
   	@group = current_user.groups.find(params[:id])
   	if @group
   		@users = @group.users.where("id != #{current_user.id}")
   		render :json => @users.to_json(:except => [:encrypted_password,:parent_id,:created_at,
     																			:updated_at,:sign_in_count,:current_sign_in_at,
     																			:last_sign_in_at,:current_sign_in_ip,
     																			:last_sign_in_ip,:user_creation_limit,
     																			:photo_file_name,:photo_content_type,:photo_file_size,
     																			:photo_updated_at,:device_type,:device_registration_id],:methods => [:group_name,:role_name,:userid,:mini_photo_url,:title_name])
      
   	else
   		render :json => {:error => "You are not authenticate to access this group."}.to_json
   	end
   end
   
   def hospital_groups
   	@groups = current_user.hospital.groups
   	render :json => @groups.to_json(:only => [:id,:name])
   end
   
   def hospital_groups_users
	   @group = current_user.hospital.groups.find(params[:id])
   	if @group
   		@users = @group.users.where("id != #{current_user.id}")
   		render :json => @users.to_json(:except => [:encrypted_password,:parent_id,:created_at,
     																			:updated_at,:sign_in_count,:current_sign_in_at,
     																			:last_sign_in_at,:current_sign_in_ip,
     																			:last_sign_in_ip,:user_creation_limit,
     																			:photo_file_name,:photo_content_type,:photo_file_size,
     																			:photo_updated_at,:device_type,:device_registration_id],:methods => [:group_name,:role_name,:userid,:mini_photo_url,:title_name])
   	else
   		render :json => {:error => "You are not authenticate to access this group."}.to_json
   	end
   end
	
end
