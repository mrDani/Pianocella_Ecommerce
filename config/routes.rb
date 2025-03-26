Rails.application.routes.draw do
  get "carts/show"
  get "categories/show"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  root "products#index" # Front page = all products

  resources :products, only: [:index, :show]
  resources :categories, only: [:show]

  resource :cart, only: [:show] do
    post 'add/:product_id', to: 'carts#add', as: :add_to
    patch 'update/:product_id', to: 'carts#update', as: :update_item
    delete 'remove/:product_id', to: 'carts#remove', as: :remove_item
  end
  
  
  # Health & PWA endpoints (optional but good)
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
