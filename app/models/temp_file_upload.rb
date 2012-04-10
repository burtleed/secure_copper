class TempFileUpload < ActiveRecord::Base

  has_attached_file :data, 
      :url => "/system/temp_files/:id/:style/:basename.:extension",
      :path => ":rails_root/public/system/temp_files/:id/:style/:basename.:extension"


  validates_attachment_presence :data
  #validates_attachment_size :data, :less_than => 1.megabytes  
  #validates_attachment_content_type :data, :content_type => ['image/jpeg', 'image/jpg', 'image/png', 'image/gif','text/html','text/plain','application/pdf','application/xls','application/doc','application/msword','application/zip']
  def file_size
    if self.data_file_size < 1024
        result = self.data_file_size
        suffix = 'Bytes'
    else
        result = self.data_file_size / 1024
        suffix = 'KB'
        if result > 1000
          result = result / 1000
          suffix = 'MB'
        end
    end
    file_size = "(#{result}#{suffix})"
    return file_size
  end
end