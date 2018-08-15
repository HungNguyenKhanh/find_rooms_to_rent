Rails.application.routes.draw do
  devise_for :users, path: "",
   path_names: {sign_in: "login", sign_out: "logout", edit: "profile",
     sign_up: "registration"},
   controllers: {omniauth_callbacks: "omniauth_callback",
     registrations: "registrations", confirmations: "confirmations"}
  root "pages#home"
  get "search", to: "search#index"
  get "/change_locale/:locale", to: "settings#change_locale", as: :change_locale
  get "dashboard", to: "dashboards#index"
  get "host_calendar", to: "calendars#index"
  resources :users, only: [:show]
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

  resources :conversations, only: [:index, :create]  do
    resources :messages, only: [:index, :create]
  end
  mount ActionCable.server => "/cable"
end
