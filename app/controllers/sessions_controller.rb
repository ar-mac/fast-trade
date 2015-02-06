class SessionsController < ApplicationController
  
  before_action :no_user, only: [:new, :create]
  
  def new
    @title = I18n.t('links.crumbs.users.login')
  end
  
  def create
    @user = User.find_by(name: params[:session][:name])
    if @user && @user.authenticate(params[:session][:password])
      params[:session][:remember] == '1' ? remember(@user) : forget
      log_in(@user)
      flash[:success] = I18n.t('flash.successful.user.login')
      redirect_forward_or(root_path)
    else
      flash.now[:danger] = I18n.t('flash.error.user.login_credentials')
      render 'new'
    end
  end
  
  def destroy
    if current_user
      log_out
      redirect_to root_path, flash: {success: I18n.t('flash.successful.user.logout')}
    else
      redirect_to root_path, flash: {danger: I18n.t('flash.error.user.non_logged')}
    end
  end
end
