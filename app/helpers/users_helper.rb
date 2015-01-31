module UsersHelper
  
  def offer_status_nav
    if current_user? || admin?
      render 'status_nav'
    end
  end
  
  def account_status_text(user)
    if user.active?
      raw("<b class='text-success'>#{t('activerecord.attributes.user.active')}</b>")
    else
      raw("<b class='text-danger'>#{t('activerecord.attributes.user.inactive')}</b>")
    end
  end
  
end
