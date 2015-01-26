class SessionsController < ApplicationController
  
  before_action :no_user, only: [:new, :create]
  
  def new
    
  end
  
  def create
    @user = User.find_by(name: params[:session][:name])
    if @user && @user.authenticate(params[:session][:password])
      params[:session][:remember] == '1' ? remember(@user) : forget
      log_in(@user)
      redirect_to root_path, flash: {success: I18n.t('flash.successful_login')}
    else
      flash.now[:danger] = I18n.t('flash.wrong_login_credentials')
      render 'new'
    end
  end
  
  def destroy
    if current_user
      log_out
      redirect_to root_path, flash: {success: I18n.t('flash.successful_logout')}
    else
      redirect_to root_path, flash: {danger: I18n.t('flash.non_logged_error')}
    end
  end
end
