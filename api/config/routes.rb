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

  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "api/graphql"

  constraints(Constraints::AdminConstraint.new) do
    mount MissionControl::Jobs::Engine, at: "/jobs"
    mount Avo::Engine => "admin"
    resources :audio_transfers, only: [:new, :create]
  end

  namespace :api do
    post "/graphql", to: "graphql#execute"
  end

  resources :recordings, only: [:show]
  resources :audio_variants, only: [:show]

  post "auth/facebook/data-deletion", to: "auth#facebook_data_deletion"

  get "/landing", to: "pages#landing"
  get "/privacy", to: "pages#privacy"
  get "/terms", to: "pages#terms"
  get "/data-deletion", to: "pages#data_deletion"
  get "/dashboard", to: "pages#dashboard"

  root "pages#landing"
  get "up", to: "rails/health#show", as: :rails_health_checkb
end
