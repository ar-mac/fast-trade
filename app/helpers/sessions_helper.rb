module SessionsHelper
  
    def log_in(user)
      session[:user_id] = user.id
    end
    
    def remember(user)
      cookies.permanent.signed[:user_id] = user.id
    end
    
    def log_out
      session.delete(:user_id)
      forget
    end
    
    def forget
      cookies.delete(:user_id)
    end
    
    def logged_in?
      !current_user.nil?
    end
    
    def current_user
      u_id = session[:user_id] 
      u_id ||= cookies.signed[:user_id]
      current = User.find_by(id: u_id)
      log_in(current) if !current.nil?
      return current
    end
    
    def current_user?
      return false if @current_user.nil?
      return true if @current_user == @user
    end
    
    def owner?(owner)
      return false if @current_user.nil?
      return true if @current_user == owner
      return false
    end
    
    def admin?
      return true if @current_user.try(:admin?)
      return false
    end
    
    def current_or_admin?(owner=nil)
      return false if @current_user.nil?
      return true if @current_user == owner
      return true if current_user? || admin?
      return false
    end
    
    def inactive?
      return true if @current_user.try(:inactive?)
      return false
    end
    
    def active?
      return true if @current_user.try(:active?)
      return false
    end
    
    def store_location
      session[:back_url] = session[:forward_url]
      session[:forward_url] = request.original_url if request.get?
    end
    
    def redirect_back_or(provided, msg={})
      msg.symbolize_keys! if msg
      if !session[:back_url].nil? && (session[:back_url].split(/\/\//).first != I18n.locale)
        session[:back_url].gsub!(/\/[a-z]{2,}\//, "/#{I18n.locale}/")
      end
      if session[:back_url]
        redirect_to session[:back_url], flash: msg
        
        #prevents getting into loops if back_url is causing calling redirect_back_or
        session[:forward_url] = provided 
      else
        redirect_to provided
      end
    end
    
    def redirect_forward_or(provided, msg={})
      msg.symbolize_keys! if msg
      if session[:forward_url]
        redirect_to session[:forward_url], flash: msg
      else
        redirect_to provided
      end
    end
    
  
end
