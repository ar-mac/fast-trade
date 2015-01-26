class UsersController < ApplicationController
  
  before_action :current, only: [:show, :edit, :update, :destroy]
  before_action :get_user, only: [:show, :edit, :update, :destroy]
  before_action :get_admin, only: :index
  #before_action :no_user, only: [:new, :create]
  
  def show
    
  end

  # index should be visible only for admins
  def index
    
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
    
    def get_user
      @user = User.find_by(id: params[:id])
      
      # temporary implementation of redirection to previous (do it in the cleaner way)
      if !@user
        flash[:danger] = I18n.t('flash.no_user_error')
        redirect_to root_path
      end
    end
    
    def current
      if !logged_in?
        flash[:danger] = I18n.t('flash.non_logged_error')
        # temporary redirect should redirect to login_path and store location
        redirect_to root_path
      end
    end
    
    def no_user
      if logged_in?
        flash[:danger] = I18n.t('flash.logged_error')
        # temporary redirect should redirect back
        redirect_to root_path
      end
    end
    
    def get_admin
      if current_user.nil? || !current_user.admin?
        flash[:danger] = I18n.t('flash.user_not_admin_error')
        redirect_to root_path
      end
    end
  
end
