class UsersController < ApplicationController
  
  #finds out who is current and sets to @current_user
  before_action :get_current
  
  #finds user who is object of the action
  before_action :get_user, only: [:show, :edit, :update, :destroy]
  
  #allows only admin to do action
  before_action :admin_auth, only: :index
  
  #allows only logged users to do action
  before_action :logged_user, only: [:show, :edit, :update, :destroy]
  
  #allows only owner of the account (and admin) to do action
  before_action :owner_user, only: [:edit, :update, :destroy]
  
  #allows only non logged users to do action
  before_action :no_user, only: [:new, :create]
  
  #visible for all logged in
  def show
    
  end

  # index should be visible only for admins
  def index
    
  end
  
  #only for non logged
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
    #password change
    if @user.authenticate(params[:old_password]) && @current_user == @user
      password_change = true
      flash[:info] = I18n.t('flash.successful.password_change')
    else
      password_change = false
    end
    
    if @user.update(user_params(password_change))
      flash[:success] = I18n.t('flash.successful.profile_update')
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    if @user.active?
      @user.toggle!(:active)
      redirect_to root_path, flash: {info: I18n.t('flash.successful.account_deletion')}
    else
      redirect_to root_path, flash: {danger: I18n.t('flash.successful.no_such_action')}
    end
  end
  
  private
  
    def user_params(password_change=true)
      if password_change
        params.require(:user).permit(:name, :region,:password, :password_confirmation)
      else
        params.require(:user).permit(:name, :region)
      end
    end
    
    def get_user
      @user = User.find_by(id: params[:id])
      
      # temporary implementation of redirection to previous (do it in the cleaner way)
      if !@user
        flash[:danger] = I18n.t('flash.error.no_user')
        redirect_to root_path
      end
    end
    
    def logged_user
      if @current_user.nil?
        flash[:danger] = I18n.t('flash.error.non_logged')
        # temporary redirect should redirect to login_path and store location
        redirect_to login_path
      end
    end
    
    def owner_user
      if !(@current_user == @user || @current_user.admin?)
        flash[:danger] = I18n.t('flash.error.not_owner')
        # temporary redirect should redirect to prev location
        redirect_to root_path
      end
    end
    
    def admin_auth
      if current_user.nil? || !current_user.admin?
        flash[:danger] = I18n.t('flash.error.user_not_admin')
        redirect_to root_path
      end
    end
  
end
