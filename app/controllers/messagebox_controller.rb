class MessageboxController < ApplicationController
  
  #allows only logged_in users to do action
  before_action :logged_user
  before_action :get_issues
  
  def box
    
  end
  
  private
    
    def get_issues
      ['recieved', 'send'].include?(params[:type]) ? @type = params[:type] : @type = 'recieved'
      user_type = (@type == 'recieved' ?  'reciever' : 'sender')
      
      @issues = @current_user.send("#{@type}_issues")
      .where("active_for_#{user_type} = ?", true)
      .paginate(page: params[:page])
    end
  
end
