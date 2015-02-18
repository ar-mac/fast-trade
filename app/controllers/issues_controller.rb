class IssuesController < ApplicationController
  
  before_action :get_issue
  before_action :issue_owner
  
  def deactivate
    if owner?(@issue.sender)
      @issue.sender_deactivate
    else
      @issue.reciever_deactivate
    end
    if both_deactivate?
      @issue.destroy
    end
    flash[:success] = I18n.t('flash.successful.issue.deactivation')
    redirect_back
  end
  
  private
    
    def get_issue
      @issue = Issue.find(params[:id])
    end
    
    def issue_owner
      if !(owner?(@issue.sender) || owner?(@issue.reciever))
        flash[:danger] = I18n.t('flash.error.issue.not_owner')
      end
    end
  
end
