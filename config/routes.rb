# frozen_string_literal: true

Rails.application.routes.draw do
  get "up", to: "rails/health#show", as: :rails_health_check

  root to: "pages#home"
end
