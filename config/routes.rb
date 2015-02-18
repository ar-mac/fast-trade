Rails.application.routes.draw do
  
  get 'messagebox/outbox'

  get 'messagebox/inbox'

  get 'messageboxes/outbox'

  get 'messageboxes/inbox'

  get '/:locale' => 'statics#home'
  root 'statics#home'
  
  scope "(:locale)", locale: /pl|en|es/ do
    get 'locale/change' => 'statics#locale', as: :locale
    resources :users, except: [:index, :new]
    get 'register' => 'users#new', as: :new_user
    patch 'users/:id/activate' => 'users#activate', as: :activate_user
    patch 'users/:id/deactivate' => 'users#deactivate', as: :deactivate_user
    
    resources :offers
    patch 'offers/:id/close' => 'offers#close', as: :close_offer
    patch 'offers/:id/renew' => 'offers#renew', as: :renew_offer
    patch 'offers/:id/accept' => 'offers#accept', as: :accept_offer
    
    get 'users' => 'users#index', as: :admin_users
    
  	get 'login' => 'sessions#new', as: :login
  	post 'login' => 'sessions#create', as: :sessions
  	delete 'logout' => 'sessions#destroy', as: :logout
  	
  	patch 'issues/:id/deactivate' => 'issues#deactivate', as: :deactivate_issue
  	resources :messages, only: [:new, :create]
	end
	
end
