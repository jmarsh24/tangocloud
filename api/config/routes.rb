Rails.application.routes.draw do
  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  resources :sessions, only: [:index, :show, :destroy]
  resource :password, only: [:edit, :update]
  namespace :identity do
    resource :email, only: [:edit, :update]
    resource :email_verification, only: [:show, :create]
    resource :password_reset, only: [:new, :edit, :create, :update]
  end
  namespace :authentications do
    resources :events, only: :index
  end
  get "/auth/failure", to: "sessions/omniauth#failure"
  get "/auth/:provider/callback", to: "sessions/omniauth#create"
  post "/auth/:provider/callback", to: "sessions/omniauth#create"

  get "/apple-app-site-association", to: "apple_app_site_association#show", as: :apple_app_site_association
  get "/.well-known/apple-app-site-association", to: "apple_app_site_association#show"
  get "/.well-known/change-password", to: "passwords#edit", as: :change_password

  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "api/graphql"
  end

  constraints(Constraints::AdminConstraint.new) do
    mount MissionControl::Jobs::Engine, at: "/jobs"
    mount Avo::Engine => "admin"
    resources :audio_transfers, only: [:new, :create]
  end

  namespace :api do
    post "/graphql", to: "graphql#execute"
  end

  root "pages#home"
  get "up", to: "rails/health#show", as: :rails_health_check
end
