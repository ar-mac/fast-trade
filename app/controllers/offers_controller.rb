class OffersController < ApplicationController
  
  #finds out who is current and sets to @current_user
  before_action :get_current
  
  #finds offert which is object of the action
  before_action :get_offer, only: [:show, :edit, :update, :destroy]
  
  #allows only owner of the account (and admin) to do action
  before_action :owner_user, only: [:edit, :update, :destroy]
  
  def show
    
  end

  def index
    @offers = Offer.by_search_params(params, admin?)
  end

  def new
  end
  
  def create
  end

  def edit
  end
  
  def update
  end
  
  def destroy
  end
  
  private
  
    def get_offer
      @offer = Offer.find_by(id: params[:id])
    end
    
    def owner_user
      if @current_user.nil? || !(@current_user == @offer.owner || @current_user.admin?)
        flash[:danger] = I18n.t('flash.error.not_owner')
        # temporary redirect should redirect to prev location
        redirect_to root_path
      end
    end
end
