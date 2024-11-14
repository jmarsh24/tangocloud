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

  get "/apple-app-site-association", to: "apple_app_site_association#show", as: :apple_app_site_association
  get "/.well-known/apple-app-site-association", to: "apple_app_site_association#show"

  authenticate :admin do
    mount MissionControl::Jobs::Engine, at: "/jobs"
    mount Avo::Engine, at: Avo.configuration.root_path
  end

  resource :player, only: :show
  resource :library, only: :show
  resource :sidebar, only: :show

  resource :playback, only: [] do
    post :play
    post :pause
    post :next
    post :previous
    post :update_volume
    post :mute
    post :unmute
  end

  concern :queueable do
    post "queue/add", to: "queues#add", as: :add_to_queue
    post "queue/select", to: "queues#select", as: :select_recording
    delete "queue/remove", to: "queues#remove", as: :remove_from_queue
  end

  resource :queue, only: :show do
    post :add, on: :collection
    post :select, on: :collection
    delete :remove, on: :collection
  end

  resources :queue_items, only: [] do
    patch :reorder, on: :member
  end

  resources :library_items, only: [] do
    patch :reorder, on: :member
  end

  resources :playlists, only: [:new, :index, :create, :show, :update, :destroy] do
    member do
      post 'add_to_library', to: 'user_libraries#add_playlist'
      get :add_to
      post :add_recording
      post :add_tanda
    end
    resources :recordings, only: [:index, :create, :destroy], module: :playlists do
      member do
        post :load
        put :move
      end
      delete :destroy_all, on: :collection
    end
    resources :tandas, only: [:index, :show] do
      resources :recordings, only: [] do
        member { post :load, to: "tandas/recordings#load" }
      end
    end
  end

  resources :tandas, only: [:new, :index, :show] do
    member { post 'add_to_library', to: 'user_libraries#add_tanda' }
    resources :recordings, only: [] do
      member { post :load, to: "tandas/recordings#load" }
    end
  end

  resources :recordings, only: [:show, :index] do
    resource :like, only: [:create, :destroy], module: :recordings
  end

  resources :orchestras, only: [:index, :show] do
    resources :recordings, only: [] do
      member { post :load, to: "orchestras/recordings#load" }
    end
  end

  resource :music_library, only: :show do
    resources :recordings, only: [] do
      member { post :load, to: "music_libraries/recordings#load" }
    end
  end

  namespace :modal do
    resources :playlists, only: [:index, :new, :edit]
  end

  resources :search, only: [:index] do
    collection do
      post :recordings
      post :tandas
    end
  end
  
  post "search/recording/load", to: "searches/recordings#load", as: :load_search_recording
  post "queue/recording/load", to: "queues/recordings#load", as: :load_queue_recording

  resources :digital_remaster, only: [:new, :create]

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  post "auth/facebook/data-deletion", to: "auth#facebook_data_deletion"
  get "/landing", to: "pages#landing"
  get "/privacy", to: "pages#privacy"
  get "/terms", to: "pages#terms"
  get "/data-deletion", to: "pages#data_deletion"
  get "/dashboard", to: "pages#dashboard"

  get "up", to: "rails/health#show", as: :rails_health_check
  root "pages#landing"
end