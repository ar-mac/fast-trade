class UsersController < ApplicationController
  
  before_action :get_user, only: [:show, :edit, :update, :destroy]
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
      @user = User.find_by(params[:id])
      
      # temporary implementation (do it in the cleaner way)
      if !@user
        flash[:danger] = I18n.t('flash.no_user_error')
        redirect_to :back || root_path
      end
    end
  
end
