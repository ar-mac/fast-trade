module MessagesHelper
  
  
  def is_new?(msg)
    true if msg.new_for_user_id == @current_user.id
  end
  
  
end
