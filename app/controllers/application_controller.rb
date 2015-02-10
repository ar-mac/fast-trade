class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  include SessionsHelper
  
  #finds out who is current and sets to @current_user
  before_action :get_current
  
  #sets locale according to 
  before_action :set_locale
  
  def set_locale
    I18n.locale = params[:locale]
  end
  
  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end
  
  def get_current
    @current_user = current_user
    store_location
  end
  
  def no_user
    if logged_in?
      flash[:danger] = I18n.t('flash.error.user.logged')
      # temporary redirect should redirect back
      redirect_to root_path
    end
  end
  
  def admin_auth
    if current_user.nil? || !current_user.admin?
      flash[:danger] = I18n.t('flash.error.user.not_admin')
      redirect_back_or root_path
    end
  end
  
  def logged_user
    if !logged_in?
      redirect_to login_path, flash: { danger: I18n.t('flash.error.user.non_logged') }
    end
  end
  
  def active_account
    if inactive?
      redirect_to root_path, flash: { danger: I18n.t('flash.error.user.non_active') }
    end
  end
  
end
