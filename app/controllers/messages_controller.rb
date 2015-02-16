class MessagesController < ApplicationController
  
  before_action :get_offer, only: [:new, :create]
  before_action :offer_for_issue, only: [:new]
  
  def new
    @title = I18n.t('links.crumbs.message.new')
    if @issue.new_record?
      @issue.sender_id = @current_user.id
      @issue.reciever_id = @offer.owner.id
      @issue.offer_id = @offer.id
    end
    @message.author_id = @current_user.id
  end
  
  def create
    
    unless @issue = @current_user.send_issues.where('offer_id = ?', @offer.id).first
      unless @issue = @current_user.send_issues.create(issue_params)
        back_to_message
        return
      end
    end
    
    if @message = @issue.messages.create(message_params)
      #if message updates properly it succesfully ends
      redirect_to @issue.offer, flash: {success: I18n.t('flash.successful.message.creation')}
    else
      back_to_message
    end
    
  end
  
  private
  
    def issue_params
      params.require(:issue).permit(:title, :sender_id, :reciever_id, :offer_id)
    end
    
    def message_params
      params.require(:message).permit(:content, :author_id)
    end
    
    def get_offer
      @offer = Offer.find_by(id: params[:offer_id])
    end
    
    def back_to_message
      render('new', {offer_id: @offer}) and return
    end
    
    def offer_for_issue
      unless @issue = @current_user.send_issues.where('offer_id = ?', @offer.id).first
        @issue = @current_user.send_issues.new()
      end
      @message = @issue.messages.new()
    end
  
end
