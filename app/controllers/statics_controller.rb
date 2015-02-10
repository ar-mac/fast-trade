class StaticsController < ApplicationController
  
  before_action :get_current
  
  def home
    
  end
  
  def locale
    redirect_back_or root_path
  end
  
end
