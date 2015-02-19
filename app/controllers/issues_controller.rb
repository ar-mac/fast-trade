class IssuesController < ApplicationController
  
  before_action :get_issue
  
  def show
    
    @offer = @issue.offer
    @message = @issue.messages.new()
    @message.author_id = @current_user.id
    
  end
  
  def deactivate
    if owner?(@issue.sender)
      @issue.sender_deactivate
      flash[:success] = I18n.t('flash.successful.issue.deactivation')
    elsif owner?(@issue.reciever)
      @issue.reciever_deactivate
      flash[:success] = I18n.t('flash.successful.issue.deactivation')
    else
      flash[:danger] = I18n.t('flash.error.issue.not_owner')
      redirect_back and return
    end
    
    if @issue.both_deactivate?
      @issue.destroy
    end
    redirect_back and return
  end
  
  private
    
    def get_issue
      @issue = Issue.find(params[:id])
    end
  
end
