Rails.application.routes.draw do
  extend Authenticator

  get "sign_in", to: "sessions#new"
  post "sign_in", to: "sessions#create"
  get "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  resources :registrations, only: [:edit, :update, :destroy] do
    delete :destroy, on: :collection
  end
  resources :sessions, only: [:index, :show, :destroy]
  resource :password, only: [:edit, :update]
  namespace :identity do
    resource :email, only: [:edit, :update]
    resource :email_verification, only: [:new, :show, :create, :edit]
    resource :password_reset, only: [:new, :edit, :create, :update]
  end
  namespace :authentications do
    resources :events, only: :index
  end

  get "/apple-app-site-association", to: "apple_app_site_association#show", as: :apple_app_site_association
  get "/.well-known/apple-app-site-association", to: "apple_app_site_association#show"

  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "api/graphql"

  authenticate :admin do
    mount MissionControl::Jobs::Engine, at: "/jobs"
    mount Avo::Engine, at: Avo.configuration.root_path
  end

  namespace :api do
    post "/graphql", to: "graphql#execute"

    post :login, to: "sessions#create"
    delete :logout, to: "sessions#destroy"
    post :refresh, to: "refresh#create"

    post :google_login, to: "sessions#google_login"
    post :apple_login, to: "sessions#apple_login"

    resources :users, only: [:show, :create, :edit, :update]
    resources :audio_variants, only: [:show]
    resources :recordings, only: [:show]
  end

  resources :digital_remaster, only: [:new, :create]
  resources :recordings, only: [:index]
  resources :orchestras, only: [:index, :show]
  resources :playlists, only: [:index, :show]
  resources :tandas, only: [:index, :show]
  resource :player, only: [:create]

  post "auth/facebook/data-deletion", to: "auth#facebook_data_deletion"

  get "/landing", to: "pages#landing"
  get "/privacy", to: "pages#privacy"
  get "/terms", to: "pages#terms"
  get "/data-deletion", to: "pages#data_deletion"
  get "/dashboard", to: "pages#dashboard"

  root "pages#landing"
  get "up", to: "rails/health#show", as: :rails_health_checkb
end
