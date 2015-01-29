module UsersHelper
  
  def password_fields
    if @current_user == @user
      render partial: 'users/form_fields', locals: {edit: true}
    elsif @current_user.nil?
      render partial: 'users/form_fields', locals: {edit: false}
    else
      
    end
  end
  
  def offer_status_nav
    if current_user? || admin?
      render 'status_nav'
    end
  end
  
end
