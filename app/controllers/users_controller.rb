class UsersController < ApplicationController
  
  before_action :get_current
  before_action :user_auth, only: [:show, :edit, :update, :destroy]
  before_action :get_user, only: [:show, :edit, :update, :destroy]
  before_action :admin_auth, only: :index
  before_action :no_user, only: [:new, :create]
  
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
    
    def user_auth
      if !logged_in?
        flash[:danger] = I18n.t('flash.non_logged_error')
        # temporary redirect should redirect to login_path and store location
        redirect_to root_path
      end
    end
    
    def admin_auth
      if current_user.nil? || !current_user.admin?
        flash[:danger] = I18n.t('flash.user_not_admin_error')
        redirect_to root_path
      end
    end
  
end
