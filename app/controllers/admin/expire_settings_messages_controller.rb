class Admin::ExpireSettingsMessagesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @expire_setting = ExpireSettingsMessage.find_or_create_by_user_id(current_user.id)
    render :layout => false
  end

  def update
    @expire_setting = ExpireSettingsMessage.find_by_user_id(current_user.id)
    @expire_setting.update_attributes(params[:expire_settings_message])
    respond_to do|format|
      if @expire_setting.valid?
        format.html{redirect_to admin_messages_path}
        format.js 
      else
        format.html{render :action => "new"}
        format.js
      end
    end
  end

end