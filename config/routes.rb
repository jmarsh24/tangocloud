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

  resource :player, only: [:show]
  resource :sidebar, only: [:show]

  resource :playback do
    post :play, on: :member
    post :pause, on: :member
    post :next, on: :member
    post :previous, on: :member
    post :update_volume, on: :member
    post :mute, on: :member
    post :unmute, on: :member
  end

  resource :queue, only: [:show] do
    collection do
      post :add
      post :select
      delete :remove
    end
  end

  resources :queue_items, only: [] do
    patch :reorder, on: :member
  end

  resources :library_items, only: [:destroy] do
    patch :reorder, on: :member
    collection do
      post :index
    end
  end

  concern :queueable do
    post "queue/add", to: "queues#add", as: :add_to_queue
    post "queue/select", to: "queues#select", as: :select_recording
    delete "queue/remove", to: "queues#remove", as: :remove_from_queue
  end

  resources :playlists do
    member do
      post "add_to_library", to: "user_libraries#add_playlist"
    end
  end

  resources :tandas do
    member do
      post "add_to_library", to: "user_libraries#add_tanda"
    end
  end

  resources :recordings, only: [:show, :index] do
    resource :like, only: [:create, :destroy], module: :recordings
  end

  resources :playlists, only: [:index, :show] do
    resources :recordings, only: [] do
      member do
        post "load", to: "playlists/recordings#load"
      end
    end
    resources :tandas, only: [:index, :show] do
      resources :recordings, only: [] do
        member do
          post "load", to: "tandas/recordings#load"
        end
      end
    end
  end

  resources :tandas, only: [:index, :show] do
    resources :recordings, only: [] do
      member do
        post "load", to: "tandas/recordings#load"
      end
    end
  end

  resources :orchestras, only: [:index, :show] do
    resources :recordings, only: [] do
      member do
        post "load", to: "orchestras/recordings#load"
      end
    end
  end

  resource :music_library, only: [:show] do
    resources :recordings, only: [] do
      member do
        post "load", to: "music_libraries/recordings#load"
      end
    end
  end

  get "search", to: "search#index"
  post "search/recording/load", to: "searches/recordings#load", as: :load_search_recording
  post "queue/recording/load", to: "queues/recordings#load", as: :load_queue_recording

  resources :digital_remaster, only: [:new, :create]

  get "service-worker" => "rails/pwa#service_worker", :as => :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", :as => :pwa_manifest

  post "auth/facebook/data-deletion", to: "auth#facebook_data_deletion"

  get "/landing", to: "pages#landing"
  get "/privacy", to: "pages#privacy"
  get "/terms", to: "pages#terms"
  get "/data-deletion", to: "pages#data_deletion"
  get "/dashboard", to: "pages#dashboard"

  root "pages#landing"
  get "up", to: "rails/health#show", as: :rails_health_checkb
end
