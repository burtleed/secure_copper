class Attachment < ActiveRecord::Base
  belongs_to :message
  
  has_attached_file :data,
    :url => "/assets/images/:id/:style/:basename.:extension",
    :path => ":rails_root/public/assets/images/:id/:style/:basename.:extension"

	def photo_url
		"http://#{ActionController::Base.asset_host}#{self.data.url}"
	end
	
	def image?
		['image/jpg','image/jpeg','image/png','image/gif','image/bmp','image/pjpeg','image/x-png'].include? self.data_content_type
	end
end