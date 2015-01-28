module UsersHelper
  
  def password_fields
    if @current_user == @user
      render partial: 'users/form_fields', locals: {edit: true}
    elsif @current_user.nil?
      render partial: 'users/form_fields', locals: {edit: false}
    else
      
    end
  end
  
end
