Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "registrations"}

  get "/apple-app-site-association", to: "apple_app_site_association#show", as: :apple_app_site_association
  get "/.well-known/apple-app-site-association", to: "apple_app_site_association#show"

  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "api/graphql"

  mount MissionControl::Jobs::Engine, at: "/jobs"
  mount Avo::Engine => "admin"
  resources :audio_transfers, only: [:new, :create]

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
