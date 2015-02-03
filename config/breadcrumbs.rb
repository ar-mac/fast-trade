crumb :home do
  link I18n.t('links.crumbs.home'), root_path
end

crumb :offers do
  link I18n.t('links.crumbs.offers.index'), offers_path
  parent :home
end

crumb :offer do |offer|
  link_title = I18n.t('links.crumbs.offers.offer', 
    :title => truncate(offer.title, length: 20, separator: ' ')
  )
  link link_title, offer_path(offer)
  parent :offers
end

crumb :edit_offer do |offer|
  link I18n.t('links.crumbs.offers.edit'), edit_offer_path(offer)
  parent :offer, offer
end

crumb :new_offer do
  link I18n.t('links.crumbs.offers.new'), new_offer_path
  parent :offers
end

crumb :users do
  link I18n.t('links.crumbs.users.index'), users_path
  parent :home
end

crumb :user do |user|
  link_title = I18n.t('links.crumbs.users.user', 
    :name => truncate(user.name, length: 20, separator: ' ')
  )
  link link_title, user_path(user)
  parent :users
end

crumb :edit_user do |user|
  link I18n.t('links.crumbs.users.user'), edit_user_path(user)
  parent :user, user
end

crumb :new_user do
  link I18n.t('links.crumbs.users.new'), new_user_path
  parent :user
end



# crumb :projects do
#   link "Projects", projects_path
# end

# crumb :project do |project|
#   link project.name, project_path(project)
#   parent :projects
# end

# crumb :project_issues do |project|
#   link "Issues", project_issues_path(project)
#   parent :project, project
# end

# crumb :issue do |issue|
#   link issue.title, issue_path(issue)
#   parent :project_issues, issue.project
# end

# If you want to split your breadcrumbs configuration over multiple files, you
# can create a folder named `config/breadcrumbs` and put your configuration
# files there. All *.rb files (e.g. `frontend.rb` or `products.rb`) in that
# folder are loaded and reloaded automatically when you change them, just like
# this file (`config/breadcrumbs.rb`).