# frozen_string_literal: true

Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  mount ActionAuth::Engine => "action_auth"
  constraints AdminConstraint do
    mount GoodJob::Engine => "good_job"
    mount Avo::Engine => "admin"
  end

  post "/graphql", to: "graphql#execute"

  root "pages#home"
  get "up", to: "rails/health#show", as: :rails_health_check
end
