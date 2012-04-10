class ExpireSettingsMessagesController < ApplicationController
  before_filter :authenticate_user!

  def new
    @expire_setting = ExpireSettingsMessage.find_or_create_by_user_id(current_user.id)
  end

  def update
    @expire_setting = ExpireSettingsMessage.find_by_user_id(current_user.id)
    @expire_setting.update_attributes(params[:expire_settings_message])
    respond_to do|format|
      if @expire_setting.valid?
        format.html{redirect_to messages_path}
        format.json{render :json => @expire_setting.to_json}
      else
        format.html{render :action => "new"}
        format.json{render :json => {:error => "Error in saving expire setting"}.to_json}
      end
    end
  end

end