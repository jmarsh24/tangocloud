resources :digital_remaster, only: [:new, :create]
resources :recordings, only: [:show]
resources :audio_variants, only: [:show]

get "/landing", to: "pages#landing"
get "/privacy", to: "pages#privacy"
get "/terms", to: "pages#terms"
get "/data-deletion", to: "pages#data_deletion"
get "/dashboard", to: "pages#dashboard"
