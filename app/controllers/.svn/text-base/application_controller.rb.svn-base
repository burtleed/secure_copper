class ApplicationController < ActionController::Base
  #protect_from_forgery
  
  before_filter :check_current_user
  
  protected 
  
  def check_current_user
  	logger.warn("==current_user=======#{(current_user.nil?)? 'nil user' : current_user.id}=======================")
  end
  
  
  def set_page_and_per_page
  	@page = (params[:page].present?)? params[:page] : 1
  	@per_page = 10
  end
end
