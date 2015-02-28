class MessageboxController < ApplicationController
  
  #allows only logged_in users to do action
  before_action :logged_user
  
  #gets proper set of issues send/recieved/archieved for given params
  before_action :get_issues
  
  #deletes issues without messages
  before_action :clear_empty, only: [:box]
  
  #deletes old issues
  before_action :clear_old, only: [:box]
  
  def box
    @title = I18n.t("links.crumbs.messagebox.#{@type2}")
  end
  
  private
    
    def get_issues
      @type = (params[:type] == 'send' ? 'send' : 'recieved')
      user_type = (@type == 'send' ? 'sender' : 'reciever')
      status = (params[:status] == '0' ? false : true)
      @type2 = (status == false ? "#{@type}_archieve" : @type)
      
      @issues = @current_user.send("#{@type}_issues")
      .where("active_for_#{user_type} = ?", status)
      .paginate(page: params[:page])
    end
    
    def clear_empty
      #empty issue is created when user hits 'new message', 
      #but actually didn't create message.
      @issues.each do |issue|
        issue.destroy if issue.messages.empty?
      end
    end
    
    def clear_old
      @issues.each do |issue|
        issue.destroy if issue.messages.last.created_at < 30.days.ago
        issue.destroy if issue.both_deactivate? && issue.messages.last.created_at < 3.days.ago
      end
    end
    
    
  
end
