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
      log_out
      get_current
      flash[:info] = I18n.t('flash.successful.user.force_logged_out')
    end
  end
  
  def admin_auth
    if !admin?
      flash[:danger] = I18n.t('flash.error.user.cant_do_that')
      redirect_back
    end
  end
  
  def logged_user
    if !logged_in?
      session[:redirected] = true
      redirect_to login_path, flash: { danger: I18n.t('flash.error.user.non_logged') }
    end
  end
  
  def active_account
    if inactive?
      flash[:danger] = I18n.t('flash.error.user.non_active')
      redirect_back
    end
  end
  
end
