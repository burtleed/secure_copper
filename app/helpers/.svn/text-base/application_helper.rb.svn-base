module ApplicationHelper

	def show_active_menu(path)
		(request.fullpath == path)?("activemain"):("")
	end

	def show_active_menu_controller(controller_name)
	    if controller.controller_name != "users"
			(controller.controller_name == controller_name)?("activemain"):("")
		 else
		 	(controller.controller_name == controller_name && controller.action_name != "change_password")?("activemain"):("")
		 end	
	end

  def render_myoptions(collections)
  	  html = ""
  	  collections.each do |element|
  	  	 html += %Q(<option value='#{element.id}' id='optId_#{element.id}'>#{element.name}</option>)
  	  end
  	  html
  end
  
  def render_myoptions1(collections)
  	  html = ""
  	  collections.each do |element|
  	  	 html += %Q(<option value='#{element.id}' selected=selected>#{element.name}</option>)
  	  end
  	  html
  end
end
