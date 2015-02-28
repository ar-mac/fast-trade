module MessagesHelper
  
  
  def is_new?(msg)
    true if @current_user == msg.new_for_user
  end
  
  
end
