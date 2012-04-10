class PasswordsController < Devise::PasswordsController

  def new
  	super
  end
  
  def edit
   super
  end 

	def update
    self.resource = resource_class.reset_password_by_token(params[resource_name])

    if resource.errors.empty?
      flash_message = resource.active_for_authentication? ? :updated : :updated_not_active
      set_flash_message(:notice, flash_message) if is_navigational_format?
      sign_in(resource_name, resource)
      if resource.is_any_admin?
      	redirect_to admin_users_path
      else
      	redirect_to admin_messages_path
      end	 
    else
      respond_with_navigational(resource){ render_with_scope :edit }
    end
  	end
end