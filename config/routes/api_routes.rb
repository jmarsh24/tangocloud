namespace :api do
  post "/graphql", to: "graphql#execute"

  post :login, to: "sessions#create"
  delete :logout, to: "sessions#destroy"
  post :refresh, to: "refresh#create"

  post :google_login, to: "sessions#google_login"
  post :apple_login, to: "sessions#apple_login"

  resources :users, only: [:show, :create]
end
