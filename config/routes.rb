Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  devise_for :users 

  resources :users do
  	resources :orders, only: [:index]
  end
  
  resources :events do
  	resources :orders
  end
  #resources :orders

  get '*unmatched_route', to: 'application#handle_record_not_found'

  root 'events#index'
end
