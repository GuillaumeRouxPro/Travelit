Rails.application.routes.draw do
  get 'home/index'
  get 'home/search', to: 'home#search'
  get 'home/result', to: 'home#result', as: 'home_result'
  devise_for :users
  root to: "tours#index"


  post '/become_guide', to: 'users#become_guide', as: 'become_guide'


  get '/tours/new', to: 'tours#new', as: 'new_tour'
  resources :bookings do
    collection do
      post :accept_refuse
    end
  end
  resources :tours do
    collection do
      get :top_match
      get :my_tours, as: :my_tours
    end
  end
  resources :hobbies, only: [:index, :new, :create]

    #resources :tours do
    #resources :bookings, only: [:new, :create]
  #end
  #patch 'accept'
     # patch 'refuse'
     # post 'chat', on: :collection
    #end
  resources :reviews, only: [:new, :create]
  #end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
