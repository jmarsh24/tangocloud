# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionAuth::Engine => "action_auth"
  constraints AdminConstraint do
    mount GoodJob::Engine => "good_job"
  end

  root "pages#home"
  get "up", to: "rails/health#show", as: :rails_health_check
end
