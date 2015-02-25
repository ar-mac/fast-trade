crumb :home do
  link I18n.t('links.crumbs.home'), root_path
end

crumb :offers do
  link I18n.t('links.crumbs.offer.index'), offers_path
  parent :home
end

crumb :offer do |offer|
  link_title = I18n.t('links.crumbs.offer.offer', 
    :title => truncate(offer.title, length: 20, separator: ' ')
  )
  link link_title, offer_path(offer)
  parent :offers
end

crumb :edit_offer do |offer|
  link I18n.t('links.crumbs.offer.edit'), edit_offer_path(offer)
  parent :offer, offer
end

crumb :new_offer do
  link I18n.t('links.crumbs.offer.new'), new_offer_path
  parent :offers
end

crumb :users do
  link I18n.t('links.crumbs.user.index'), users_path
  parent :home
end

crumb :user do |user|
  link_title = I18n.t('links.crumbs.user.user', 
    :name => truncate(user.name, length: 20, separator: ' ')
  )
  link link_title, user_path(user)
  admin? ? parent(:users) : parent(:home)
end

crumb :edit_user do |user|
  link I18n.t('links.crumbs.user.edit'), edit_user_path(user)
  parent :user, user
end

crumb :new_user do
  link I18n.t('links.crumbs.user.new'), new_user_path
  parent :home
end

crumb :login do
  link I18n.t('links.crumbs.user.login'), login_path
  parent :home
end

crumb :messagebox do |type, current_user|
  link I18n.t("links.crumbs.messagebox.#{type}"), messagebox_path(type: type)
  parent :user, current_user
end

crumb :issue do |issue|
  issue_title = I18n.t('links.crumbs.issue.title')
  link issue_title, login_path
  parent :offer, issue.offer
end