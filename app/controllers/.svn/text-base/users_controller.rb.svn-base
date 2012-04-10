class UsersController < ApplicationController
   before_filter :authenticate_user!
   
	def index
	 if current_user.is_super_admin? 
      @users = User.where("id != #{current_user.id}")
    elsif current_user.is_hospital_admin?
      @users = User.hospital_users(current_user.hospital_id).where("id != #{current_user.id}")
    else
      @users = User.group_users(current_user.primary_group_id,current_user.hospital_id).where("id != #{current_user.id}")
    end
	 respond_to do |format|
		  format.json { render :json => @users.to_json(:except => [:encrypted_password,:parent_id,:created_at,
     																			:updated_at,:sign_in_count,:current_sign_in_at,
     																			:last_sign_in_at,:current_sign_in_ip,
     																			:last_sign_in_ip,:user_creation_limit,
     																			:photo_file_name,:photo_content_type,:photo_file_size,
     																			:photo_updated_at],:methods => [:group_name,:role_name,:userid])
      }
    end  																			
	end
	
	def search
    if current_user.is_super_admin? 
      @users = User.where("email like ?","%#{params[:q]}%")
    elsif current_user.is_hospital_admin?
      @users = User.hospital_users(current_user.hospital_id).where("email like ?","%#{params[:q]}%")
    else
      @users = User.group_users(current_user.primary_group_id,current_user.hospital_id).where("email like ?","%#{params[:q]}%")
    end

    respond_to do|format|
      format.html 
      format.json{render :json => @users.map(&:attributes),:except =>[:encrypted_password]}
    end 
	end

end