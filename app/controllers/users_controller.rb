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
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in(@user)
      redirect_to @user, flash: {success: I18n.t('flash.successful.user_creation')}
    else
      render 'new'
    end
  end

  def edit
    
  end
  
  def update
    # implement admin edit
    
    #password change
    unless @user.authenticate(params[:old_password])
      params[:password] = ''
      params[:password_confirmation] = ''
    end
      
    if @user.update(user_params)
      redirect_to @user, flash: {success: I18n.t('flash.successful.profile_update')}
    else
      render 'new'
    end
  end
  
  def destroy
    
  end
  
  private
  
    def user_params
      params.require(:user).permit(:name, :region, :password, :password_confirmation)
    end
    
    def get_user
      @user = User.find_by(id: params[:id])
      
      # temporary implementation of redirection to previous (do it in the cleaner way)
      if !@user
        flash[:danger] = I18n.t('flash.error.no_user')
        redirect_to root_path
      end
    end
    
    def user_auth
      if !logged_in?
        flash[:danger] = I18n.t('flash.error.non_logged')
        # temporary redirect should redirect to login_path and store location
        redirect_to login_path
      end
    end
    
    def admin_auth
      if current_user.nil? || !current_user.admin?
        flash[:danger] = I18n.t('flash.error.user_not_admin')
        redirect_to root_path
      end
    end
  
end
