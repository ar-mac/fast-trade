class StaticsController < ApplicationController
  
  before_action :get_current
  
  def home
    
  end
  
  def locale
    change_redirect_paths
    redirect_back
  end
  
  private
    
    def change_redirect_paths
      session[:back_url].is_a? String
      session[:back_url].gsub!(/\/\?locale=(pl|en|es)/, "?locale=#{I18n.locale.to_s}")
      session[:back_url].gsub!(/\/(pl|en|es)\//, "/#{I18n.locale.to_s}/")
    end
  
end
