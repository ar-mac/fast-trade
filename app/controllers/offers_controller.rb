class OffersController < ApplicationController
  
  #finds out who is current and sets to @current_user
  before_action :get_current
  
  #allows only logged user to take action
  before_action :logged_user, only: [:new, :create, :edit, :update, :destroy, :renew, :close, :accept]
  
  #finds offert which is object of the action
  before_action :get_offer, only: [:show, :edit, :update, :destroy, :renew, :close, :accept]
  
  #finds user who is owner of the offer
  before_action :get_user, only: [:show, :edit, :update, :destroy, :renew, :close, :accept]
  
  #loads params for creation of issue
  before_action :params_for_issue, only: :show
  
  #returns issue if it exist for given attributes
  before_action :get_issue, only: :show
  
  #allows only owner of the account and admin to do action
  before_action :owner_or_admin, only: [:edit, :update, :destroy, :close]
  
  #allows only owner to do action
  before_action :only_owner, only: :renew
  
  #allows only admin and owner to see pending and closed offers
  before_action :protect_pending_closed, only: :show
  
  #allows only active current_user to do action
  before_action :active_account, only: [:new, :create, :edit, :update, :renew, :close]
  
  #allows only admin to do action
  before_action :admin_auth, only: :accept
  
  #updates status to closed if offer is expired
  after_action :update_expired, only: [:index]
  
  def show
    @title = I18n.t('links.crumbs.offer.offer', title: @offer.short_title)
  end

  def index
    @title = I18n.t('links.crumbs.offer.index')
    @offers = Offer.by_search_params(params, admin?)
  end

  def new
    @title = I18n.t('links.crumbs.offer.new')
    @offer = @current_user.offers.new
  end
  
  def create
    @offer = @current_user.offers.new(offer_params)
    @offer.prepare_to_save
    if @offer.save
      redirect_to @offer, flash: {success: I18n.t('flash.successful.offer.creation')}
    else
      render 'new'
    end
  end

  def edit
    @title = I18n.t('links.crumbs.offer.edit_offer', title:  @offer.short_title)
  end
  
  def update
    if @offer.update(offer_params)
      @offer.prepare_to_save
      @offer.save
      redirect_to @offer, flash: {success: I18n.t('flash.successful.offer.edition')}
    else
      render 'edit'
    end
  end
  
  def destroy
    @offer.destroy
    redirect_to @user, flash: {info: I18n.t('flash.successful.offer.deletion')}
  end
  
  def renew
    @offer.make_pending
    redirect_to @offer, flash: {info: I18n.t('flash.successful.offer.renewation')}
  end
  
  def close
    @offer.close
    redirect_to @offer, flash: {info: I18n.t('flash.successful.offer.close')}
  end
  
  def accept
    @offer.accept
    redirect_to @offer, flash: {info: I18n.t('flash.successful.offer.acceptation')}
  end

  
  private
  
    def offer_params
      params.require(:offer).permit(:title, :valid_until, :category_id, :content, :price)
    end
    
    def params_for_issue
      if logged_in? && active? && !owner?(@user)
        @params_for_issue = 
          {
            issue: 
              {
                sender_id: @current_user.id,
                reciever_id: @user.id,
                offer_id: @offer.id
              }
          }
      end
    end
  
    def get_offer
      @offer = Offer.find_by(id: params[:id])
    end
    
    def get_issue
      if logged_in?
        @issue = Issue.where('offer_id = ? AND sender_id = ?', @offer.id, @current_user.id).first
      end
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
    
    def get_user
      @user = @offer.owner
    end
    
    def update_expired
      @offers.each { |o| o.expired? ? o.close : nil }
    end
    
    def protect_pending_closed
      if !current_or_admin?(@user) && !@offer.active?
        flash[:danger] = I18n.t('flash.error.user.cant_do_that')
        redirect_back
      end
    end
    
end
