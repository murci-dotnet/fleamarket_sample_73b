Rails.application.routes.draw do
  get 'categories/index'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    get  'sending_destinations', to: 'users/registrations#new_address'
    post 'sending_destinations', to: 'users/registrations#create_address'
    get  '/users/:user_id/sessions', to: 'users/sessions#index'
  end

  root 'items#index'

  resources :items, except: [:show] do
    collection do
      get :search
    end
  end
  
  resources :items do
    scope module: :items do
      resources :cards, only:[:new, :create, :show, :destroy]
    end
    collection do
      get  'done', to:'items#done'
    end
    member do
      get "purchase"
      post "pay"
    end
    resources :comments, only: :create
  end
  
  resources :users, only: :show do
    member do
      get "sending_destination"
    end
  end

  resources :users do
    scope module: :users do
      resources :sessions, only: [:index, :destroy]
      resources :cards,    only: [:index, :new, :create]
    end
  end
  
  resources :categories, only: [:index, :show]

end
