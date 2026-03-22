Rails.application.routes.draw do
  root "posts#index"

  devise_for(
    :users,
    module: "users",
    controllers: { registrations: "users/registrations", sessions: "users/sessions" }
  )

  devise_scope :user do
    get "login", to: "users/sessions#new"
    delete "logout", to: "users/sessions#destroy"
    get "sign_up", to: "users/registrations#new"
  end

  namespace :users do
    resources :follows, only: %i[ create destroy ]
    resources :follow_requests, only: %i[ create destroy ]
  end

  resources :posts do
    resources :comments, only: %i[ create destroy ]
    resources :likes, only: %i[ create destroy ]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
