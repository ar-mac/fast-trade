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
    
    def admin?
      return false if @current_user.nil?
      return true if @current_user.admin?
    end
    
    def current_or_admin?(owner=nil)
      return false if @current_user.nil?
      return true if @current_user == owner
      return true if current_user? || admin?
      return false
    end
    
    def inactive?
      return true if @current_user && !@current_user.active?
      return false
    end
    
    def owner?(owner)
      return false if @current_user.nil?
      return true if @current_user == owner
      return false
    end
  
end
