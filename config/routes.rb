require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  resources :products

  get :cart, to: 'carts#show'
  post :cart, to: 'carts#create'
  delete 'cart/:product_id', to: 'carts#destroy'
  put 'cart/add_item', to: 'carts#update'

  get 'up' => 'rails/health#show', as: :rails_health_check

  root 'rails/health#show'
end
