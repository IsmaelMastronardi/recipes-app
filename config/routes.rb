Rails.application.routes.draw do
  resources :foods
  devise_for :users
  resources :recipes do
    member do
      patch 'toggle_public'
      get 'new_food'
      post 'create_food'
    end
  end

  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "users#index"
end
