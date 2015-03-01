class IssuesController < ApplicationController
  
  #gets issue which is object of the action
  before_action :get_issue, only: [:show, :update]
  
  #allows only logged user to take action
  before_action :logged_user, only: [:create]
  
  #allows only active current_user to do action
  before_action :active_account, only: [:create]
  
  #owner of offer cannot create issue to his own offer
  before_action :not_owner, only: [:create]
  
  #clears new messages for current_user which were in shown issue
  after_action :dismiss_new, only: [:show]
  
  def show
    @title = I18n.t('links.crumbs.issue.title')
    @offer = @issue.offer
    @message = Message.new()
  end
  
  def create
    @issue = @reciever.recieved_issues.create(issue_params)
    redirect_to issue_path(id: @issue)
  end
  
  def update
    if owner?(@issue.sender)
      @issue.sender_deactivate
      flash[:success] = I18n.t('flash.successful.issue.deactivation')
    elsif owner?(@issue.reciever)
      @issue.reciever_deactivate
      flash[:success] = I18n.t('flash.successful.issue.deactivation')
    else
      flash[:danger] = I18n.t('flash.error.issue.not_owner')
    end
    redirect_back
  end
  
  private
    
    def get_issue
      @issue = Issue.find(params[:id])
    end
    
    def issue_params
      params.require(:issue).permit(:sender_id, :offer_id)
    end
    
    def not_owner
      @reciever = User.find_by(id: params[:issue][:reciever_id])
      if owner?(@reciever)
        flash[:danger] = I18n.t('flash.error.issue.owner')
        redirect_back
      end
    end
    
    def dismiss_new
      @issue.messages.each { |msg| msg.clear_being_new_for(@current_user) }
    end
  
end
