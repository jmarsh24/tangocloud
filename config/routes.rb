Rails.application.routes.draw do
  devise_for :users, controllers: {registrations: "registrations"}

  get "/apple-app-site-association", to: "apple_app_site_association#show", as: :apple_app_site_association
  get "/.well-known/apple-app-site-association", to: "apple_app_site_association#show"

  mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "api/graphql"

  mount MissionControl::Jobs::Engine, at: "/jobs"

  authenticate :user, ->(user) { user.admin? } do
    mount Avo::Engine => "/admin"
  end

  draw(:api_routes)
  draw(:app_routes)

  post "auth/facebook/data-deletion", to: "auth#facebook_data_deletion"

  root "pages#landing"
  get "up", to: "rails/health#show", as: :rails_health_checkb
end
