Rails.application.routes.draw do
  get "pages/show"
  get "orders/new"
  get "orders/create"
  get "orders/index"
  get "orders/show"
  get "cart/show"
  get "categories/show"
  
  devise_for :users
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  #devise_for :users, controllers: { sessions: 'devise/sessions', registrations: 'devise/registrations' }


  # For products
  root "products#index"
  resources :products, only: [:index, :show]
  resources :categories, only: [:show]

  # Cart-related routes (Fixing issue here)
  resource :cart, only: [:show], controller: 'carts' do
    post "add/:product_id", to: "carts#add_item", as: :add_item
    patch "update/:product_id", to: "carts#update_quantity", as: :update_item
    delete "remove/:product_id", to: "carts#remove_item", as: :remove_item
  end

  resources :orders, only: [:new, :create, :index, :show]


  get "/pages/:slug", to: "pages#show", as: "page"

  # Health & PWA endpoints (optional but good)
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
