class OffersController < ApplicationController
  
  #finds out who is current and sets to @current_user
  before_action :get_current
  
  #allows only logged user to take action
  before_action :logged_user, only: [:new, :create, :edit, :update, :destroy, :renew, :close, :accept]
  
  #finds offert which is object of the action
  before_action :get_offer, only: [:show, :edit, :update, :destroy, :renew, :close, :accept]
  
  #finds user who is owner of the offer
  before_action :get_user, only: [:show, :edit, :update, :destroy, :renew, :close, :accept]
  
  #allows only owner of the account and admin to do action
  before_action :owner_user, only: [:edit, :update, :destroy, :close]
  
  #allows only owner to do action
  before_action :only_owner, only: :renew
  
  #allows only active current_user to do action
  before_action :active_account, only: [:new, :create, :edit, :update, :renew, :close]
  
  #allows only admin to do action
  before_action :admin_auth, only: :accept
  
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
    @offer.status_id = 0
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
      @offer.status_id = 0
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
      params.require(:offer).permit(:title, :valid_until, :category_id, :content)
    end
  
    def get_offer
      @offer = Offer.find_by(id: params[:id])
    end
    
    def owner_user
      if !current_or_admin?
        redirect_back_or(root_path, {danger: I18n.t('flash.error.user.not_owner')})
      end
    end
    
    def only_owner
      if !current_user?
        redirect_back_or(root_path, {danger: I18n.t('flash.error.user.not_owner')})
      end
    end
    
    def get_user
      @user = @offer.owner
    end
end
