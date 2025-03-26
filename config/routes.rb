Rails.application.routes.draw do
  get "pages/show"
  get "orders/new"
  get "orders/create"
  get "orders/index"
  get "orders/show"
  get "cart/show"
  get "categories/show"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  root "products#index" # Front page = all products

  resources :products, only: [:index, :show]
  resources :categories, only: [:show]


# Cart-related routes
  resource :cart, only: [:show] do
    post "add/:product_id", to: "cart#add_item", as: :add_item
    patch "update/:product_id", to: "cart#update_quantity", as: :update_item
    delete "remove/:product_id", to: "cart#remove_item", as: :remove_item
  end

  resources :orders, only: [:new, :create, :index, :show]

get "/pages/:slug", to: "pages#show", as: "page"


  # Health & PWA endpoints (optional but good)
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
