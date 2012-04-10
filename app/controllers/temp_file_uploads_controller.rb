class TempFileUploadsController < ApplicationController
  def index
    	render  :partial => '/admin/messages/temp_files' ,:layout=>false
  end

  def create
    newparams = coerce(params)
    cnt = TempFileUpload.find(:all,:conditions => ["user_id = ? and keyname = ? ",current_user.id,session[:session_id]]).count
    if cnt.to_i < 10
      temp = TempFileUpload.create(newparams[:temp_file_upload])
      if temp.valid?
        render :xml => '<response msg="success"><temp_file id="' + temp.id.to_s + '" thumb_url="' + temp.data.url + '" /></response>' 
      else
        render :xml => 'error',:status => :unprocessable_entity
      end
    else
        render :xml => 'error',:status => :unprocessable_entity
    end
  end

  def destroy
    @temp_file = TempFileUpload.find(:first,:conditions=>["user_id = ? and queue_id_flag = ? ",current_user.id,params[:id]]) # TempFileUpload.find(params[:id])
    @temp_file.destroy
  end

  def destroy_file
    @temp_file = TempFileUpload.find(params[:id])
    @temp_file.destroy
    #redirect_to :back
  end
 
  private
  def coerce(params)
    if params[:temp_file_upload].nil?
      h = Hash.new
      h[:temp_file_upload] = Hash.new
      h[:temp_file_upload][:data] = params[:Filedata]
      h[:temp_file_upload][:data].content_type = MIME::Types.type_for(h[:temp_file_upload][:data].original_filename).to_s
      h[:temp_file_upload][:user_id] = params[:user_id]
      h[:temp_file_upload][:keyname] = params[:keyname]
      h[:temp_file_upload][:queue_id_flag] = params[:queue_id_flag]
      h
    else
      params[:temp_file_upload][:queue_id_flag] = params[:QueuID]
      params
    end
  end

end