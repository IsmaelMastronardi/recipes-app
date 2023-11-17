Rails.application.routes.draw do
  resources :public_recipes
  devise_for :users
  resources :foods
  resources :recipes do
    resources :foods, only: [] do
      member do
        post 'destroy_food_relation'
      end
    end
    member do
      patch 'toggle_public'
      get 'new_food'
      post 'create_food'
    end
  end

  resources :users do
    member do
      get 'general_shopping_list'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "users#index"
end
