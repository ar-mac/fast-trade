module IssuesHelper
  
  def sender?(issue)
    return true if @current_user == issue.sender
  end
  
  def reciever?(issue)
    return true if @current_user == issue.reciever
  end
  
end
