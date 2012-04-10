require "open-uri"
class MessageDocument < Prawn::Document

  def initialize(messages,sender,recepient)
    super(:top_margin =>  70,:page_size => "A4", :page_layout => :landscape)
    @messages = messages
    @sender = sender
    @recepient = recepient
    header_title 
    list_messages 
  end

  def header_title
    text "Messages between #{@sender.name} and #{@recepient.name}", :size => 20, :position => "center"
  end
  
  def list_messages
    move_down(20)
    table list_messages_row do
      self.header = true,
      self.row_colors = ["DDDDDD","FFFFFF"]
      self.column_widths = [100, 450, 200]
    end 
  end
  
  def list_messages_row
     [["Sender", "Message" , "Attachement Size and URL"]] + 
     @messages.map{|message|
        ["#{message.sender.name} #{sender_title(message)}", "#{message_body(message)}", "#{message.attachments.size} attachments \n #{message_attachment_urls(message)}"]     
     }
  end

  def sender_title(message)
     (message.sender.title_name.present?)? "(#{message.sender.title_name})" : "" 
  end
  
  def message_body(message)
     "#{message.body}" + "\n" + "#{message.created_at.strftime('%d-%B-%Y %H:%m')}"
  end
  
  def message_attachment_urls(message)
    attachments = ""
    message.attachments.each do |attachment|
      attachments += "#{attachment.photo_url} \n"
    end
    attachments
  end
end