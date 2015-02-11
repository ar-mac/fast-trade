class MessagesController < ApplicationController
  
  before_action :get_offer, only: [:new]
  
  def new
    
  end
  
  def create
    
  end

  def edit
    
  end
  
  def update
    
  end
  
  private
    
    def get_offer
      @offer = Offer.find_by(id: params[:offer_id])
    end
    
    def offer_for_issue
      unless @issue = @current_user.send_issues.where('offer_id = ?', @offer.id)
        @issue = @current_user.send_issues.new()
      end
      @message = @issue.messages.new()
    end
  
end
