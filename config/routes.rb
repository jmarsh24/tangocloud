Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "registrations"}

  get "/apple-app-site-association", to: "apple_app_site_association#show", as: :apple_app_site_association
  get "/.well-known/apple-app-site-association", to: "apple_app_site_association#show"

  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "api/graphql"

  mount MissionControl::Jobs::Engine, at: "/jobs"
  authenticate :user, ->(user) { user.admin? } do
    mount Avo::Engine => "/admin"
  end

  namespace :api do
    post "/graphql", to: "graphql#execute"

    post :login, to: "sessions#create"
    delete :logout, to: "sessions#destroy"
    post :refresh, to: "refresh#create"

    resources :users, only: [:show, :create]
  end

  namespace :api do
    post "/graphql", to: "graphql#execute"
  end

  resources :digital_remaster, only: [:new, :create]
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
