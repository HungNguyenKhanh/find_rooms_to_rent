Rails.application.routes.draw do
  root "pages#home"
  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  get "search", to: "search#index"
  get '/auth/:provider/callback', to: "omniauth_callback#create"
  get '/auth/failure', to: "omniauth_callback#failure"
  resources :users
  resources :rooms, except: [:edit] do
    member do
      get "listing", to: "listings#edit"
      get "pricing", to: "pricings#edit"
      get "description", to: "descriptions#edit"
      get "amenities", to: "amenities#edit"
      get "location", to: "locations#edit"
      get "photo_upload"
      get "preload"
      get "preview"
    end
    resources :photos, only: [:create, :destroy]
    resources :reservations, only: [:create]
  end
  resources :reservations, only: [:index]
  resources :trips, only: [:index]

  resources :guest_reviews, only: [:create, :destroy]
  resources :host_reviews, only: [:create, :destroy]
end
