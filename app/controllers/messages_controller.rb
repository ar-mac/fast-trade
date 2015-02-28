class MessagesController < ApplicationController
  
  before_action :logged_user
  before_action :get_issue
  
  def create
    
    if @message = Message.create(message_params)
      #if message is created properly it succesfully ends
      @issue.activate_all
      redirect_to @issue, flash: {success: I18n.t('flash.successful.message.creation')}
    else
      back_to_message
    end
  end
  
  private
  
    def issue_params
      params.require(:issue).permit(:sender_id, :reciever_id, :offer_id)
    end
    
    def message_params
      params.require(:message).permit(:content, :author_id, :issue_id)
    end
    
    def get_issue
      @issue = Issue.find_by(id: params[:message][:issue_id])
    end
    
    def back_to_message
      render('new', {offer_id: @offer}) and return
    end
  
end
