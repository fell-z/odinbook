Rails.application.routes.draw do
  root "posts#index"

  devise_for(:users, module: "users")

  devise_scope :user do
    get "login", to: "users/sessions#new"
    delete "logout", to: "users/sessions#destroy"
    get "sign_up", to: "users/registrations#new"
  end

  resources :users, shallow: true, only: :index do
    post "follows", to: "follows#send_request"
    resource :profile, only: %i[ show edit update ]
  end

  scope "/follows", as: :follow do
    get "requests", to: "follows#requests"
    patch ":id", to: "follows#accept"
    put ":id", to: "follows#accept"
    delete ":id", to: "follows#remove", as: :remove
    delete ":id/refuse", to: "follows#refuse", as: :refuse
  end

  resources :posts, shallow: true do
    resources :comments, only: %i[ create destroy ]
    resources :likes, only: %i[ create destroy ]
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
end
