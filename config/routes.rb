Rails.application.routes.draw do
  
  root 'statics#home'
  resources :users, except: :index
  
  get 'users' => 'users#index', as: :admin_users
  get 'admin/users/:id/edit' => 'users#edit', as: :edit_admin_user
  put 'admin/users/:id' => 'users#update'
	delete 'admin/users/:id' => 'users#destroy'
	
end
