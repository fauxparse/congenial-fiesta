# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :festivals, only: %i[new create]

    scope ':year', constraints: { year: /2\d{3}/ } do
      get '/' => 'festivals#show', as: :festival
    end

    root to: 'festivals#index'
  end

  get    '/login'  => 'sessions#new', as: :login
  post   '/login'  => 'sessions#create'
  delete '/logout' => 'sessions#destroy', as: :logout
  get    '/signup' => 'accounts#new', as: :signup
  post   '/signup' => 'accounts#create'

  resource :password, except: %i[show destroy] do
    get '/reset/:token' => 'passwords#reset', as: :reset
  end

  constraints(provider: /#{OmniAuth.registered_providers.join('|')}/) do
    match '/auth/:provider/callback' => 'sessions#oauth', via: %i[get post]

    resource :profile, only: %i[show update] do
      get 'connect/:provider' => 'profiles#connect', as: :connect
      delete 'connect/:provider' => 'profiles#disconnect'
    end
  end

  resources :pitches

  root to: 'festivals#show'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
