Rails.application.routes.draw do
  
  root 'statics#home'
  resources :users, except: :index
  patch 'users/:id/activate' => 'users#activate', as: :activate_user
  patch 'users/:id/deactivate' => 'users#deactivate', as: :deactivate_user
  resources :offers
  
  get 'users' => 'users#index', as: :admin_users
  
  #not sure if throw this out
  get 'admin/users/:id/edit' => 'users#edit', as: :edit_admin_user
  put 'admin/users/:id' => 'users#update'
	delete 'admin/users/:id' => 'users#destroy'
	
	get 'login' => 'sessions#new', as: :login
	post 'login' => 'sessions#create', as: :sessions
	delete 'logout' => 'sessions#destroy', as: :logout
	
end
