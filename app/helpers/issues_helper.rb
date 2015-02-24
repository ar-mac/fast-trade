module IssuesHelper
  
  def sender?(issue)
    return true if @current_user == issue.sender
  end
  
  def reciever?(issue)
    return true if @current_user == issue.reciever
  end
  
  def new_in_issue?(issue)
    return true if @current_user == issue.messages.last.new_for_user
  end
  
end
