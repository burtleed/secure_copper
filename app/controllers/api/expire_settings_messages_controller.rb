class Api::ExpireSettingsMessagesController < ApplicationController
	before_filter :authenticate_user!
	
	def show
		lifespan = (current_user.expire_settings_message.nil?) ? current_user.create_expire_settings_message  : (current_user.expire_settings_message)
		render :json => lifespan.to_json(:only => [:flag,:lifespan_hours])
	end
	
	def update
		lifespan = (current_user.expire_settings_message.nil?) ? current_user.create_expire_settings_message  : (current_user.expire_settings_message)
		if lifespan.update_attributes(:lifespan_hours => params[:lifespan_hours], :flag => params[:flag])
			render :json => lifespan.to_json(:only => [:flag,:lifespan_hours])
		else
			render :json => {:errors => lifespan.errors.full_messages }.to_json
		end
	end
end
