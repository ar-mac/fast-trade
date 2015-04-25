Rails.application.routes.draw do
  
  get 'projects/update'

  get '/:locale' => 'statics#home'
  root 'statics#home'
  
  scope "(:locale)", locale: /pl|en|es/ do
    get 'locale/change' => 'statics#locale', as: :locale
    resources :users, except: [:index, :new]
    get 'register' => 'users#new', as: :new_user
    
    patch 'activations/:id/create' => 'activations#create', as: :activate_user
    patch 'activations/:id/destroy' => 'activations#destroy', as: :deactivate_user
    
    resources :offers
    delete 'offer_statuses/:id/close' => 'offer_statuses#destroy', as: :close_offer
    patch 'offer_statuses/:id/renew' => 'offer_statuses#update', as: :renew_offer
    post 'offer_statuses/:id/accept' => 'offer_statuses#create', as: :accept_offer
    
    get 'users' => 'users#index', as: :admin_users
    
  	get 'login' => 'sessions#new', as: :login
  	post 'login' => 'sessions#create', as: :sessions
  	delete 'logout' => 'sessions#destroy', as: :logout
  	
  	resources :issues, only: [:show, :create, :update]
  	resources :messages, only: [:create]
  	resources :projects, only: [:update]
  	get 'messagebox/:type' => 'messagebox#box', as: :messagebox
	end
	
end
