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
  
end