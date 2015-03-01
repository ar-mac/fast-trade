class OfferStatusesController < ApplicationController
  
  #finds out who is current and sets to @current_user
  before_action :get_current
  
  #allows only logged user to take action
  before_action :logged_user
  
  #finds offert which is object of the action
  before_action :get_offer
  
  #finds user who is owner of the offer
  before_action :get_user
  
  #allows only owner of the account and admin to do action
  before_action :owner_or_admin, only: [:destroy]
  
  #allows only owner to do action
  before_action :only_owner, only: [:update]
  
  #allows only active current_user to do action
  before_action :active_account, only: [:update, :destroy]
  
  #allows only admin to do action
  before_action :admin_auth, only: :create
  
  def create
    @offer.accept
    redirect_to @offer, flash: {info: I18n.t('flash.successful.offer.acceptation')}
  end
  
  def update
    @offer.make_pending
    redirect_to @offer, flash: {info: I18n.t('flash.successful.offer.renewation')}
  end
  
  def destroy
    @offer.close
    redirect_to @offer, flash: {info: I18n.t('flash.successful.offer.close')}
  end
  
  private
  
    def get_offer
      @offer = Offer.find_by(id: params[:id])
    end
    
    def get_user
      @user = @offer.owner
    end
    
    def owner_or_admin
      if !current_or_admin?
        flash[:danger] = I18n.t('flash.error.user.cant_do_that')
        redirect_back
      end
    end
    
    def only_owner
      if !owner? @user
        flash[:danger] = I18n.t('flash.error.user.cant_do_that')
        redirect_back
      end
    end
    
end
