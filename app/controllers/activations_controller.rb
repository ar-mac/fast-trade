class ActivationsController < ApplicationController
  
  #finds user who is object of the action
  before_action :get_user, only: [:create, :destroy]
  
  #allows only logged users to do action
  before_action :logged_user, only: [:create, :destroy]
  
  #allows only admin to do action
  before_action :admin_auth, only: [:create, :destroy]
  
  def create
    @user.activate
    redirect_to @user, flash: {info: I18n.t('flash.successful.user.activation')}
  end
  
  def destroy
    @user.deactivate
    redirect_to @user, flash: {info: I18n.t('flash.successful.user.deactivation')}
  end
  
  private
  
    def get_user
      @user = User.find_by(id: params[:id])
      if !@user
        flash[:danger] = I18n.t('flash.error.user.not_exist')
        redirect_back
      end
    end
  
end
