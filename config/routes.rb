Rails.application.routes.draw do
  devise_for :users
  root to: "tours#index"

  resources :tours


  resources :tours do
    resources :bookings, only: [:new, :create]
    resources :reviews, only: [:index, :create]
  end

  resources :bookings, only: [:index, :show, :edit, :update, :destroy] do
    member do
      patch 'accept'
      patch 'refuse'
    end
    resources :reviews, only: [:new, :create]
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
