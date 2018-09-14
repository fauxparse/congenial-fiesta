# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :admin do
    resources :festivals, only: %i[new create edit]

    scope ':year', constraints: { year: /2\d{3}/ } do
      scope 'reports', controller: 'reports' do
        get :workshops, as: :workshops_report
      end
      resources :activities, only: %i[index create]
      resources :shows,
        controller: 'activities',
        only: %i[show update],
        defaults: { type: 'Show' }
      resources :workshops,
        controller: 'activities',
        only: %i[show update],
        defaults: { type: 'Workshop' }
      resources :people, only: %i[index show edit update]
      resources :pitches, only: %i[index show update] do
        collection do
          get '/convert' => 'pitches#select', as: :select
          post '/convert' => 'pitches#convert', as: :convert
        end
      end
      resources :payments, only: %i[index update]
      resources :registrations
      resources :schedules, path: 'timetable', except: :index
      resources :venues, only: %i[index create update destroy]
      get '/timetable' => 'schedules#index', as: :timetable
      match '/' => 'festivals#update', via: %i[put patch]
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
    get '/register/with/:provider', to: 'registrations#oauth'

    resource :profile, only: %i[show update] do
      get 'connect/:provider' => 'profiles#connect', as: :connect
      delete 'connect/:provider' => 'profiles#disconnect'
    end
  end

  get '/register/complete',
    to: 'registrations#complete',
    as: :complete_registration
  get '/register/:step', to: 'registrations#edit', as: :registration_step
  post '/register/cart', to: 'registrations#cart', as: :update_cart
  match '/register/:step', to: 'registrations#update', via: %i[put patch]
  get '/register', to: 'registrations#edit', as: :registration

  post '/payments/paypal/:id' => 'payments#paypal_callback',
       as: :paypal_callback
  match '/payments/:id' => 'payments#paypal_redirect',
        as: :paypal_return,
        via: %i[get post]

  resources :schedules, only: :show

  constraints(step: /presenter|idea|finish/) do
    resources :pitches, except: %i[show new edit create]
    get '/pitches/:id/:step', to: 'pitches#edit', as: :pitch_step
    match '/pitches/:id/:step', to: 'pitches#update', via: %i[put patch]
    get '/pitches/:id', to: 'pitches#edit', as: :edit_pitch
    get '/pitch', to: 'pitches#new', as: :new_pitch
    post '/pitch', to: 'pitches#create'
  end

  scope ':year', constraints: { year: /2\d{3}/ } do
    defaults type: 'workshop' do
      get '/workshops/:slug' => 'activities#show', as: :workshop
      get '/workshops' => 'activities#index', as: :workshops
    end

    defaults type: 'show' do
      get '/shows/:slug' => 'activities#show', as: :show
      get '/shows' => 'activities#index', as: :shows
    end
  end

  def static_page(name)
    get "/#{name.tr('_', '-')}",
      to: 'high_voltage/pages#show',
      id: name,
      as: name
  end

  static_page 'code_of_conduct'
  get '/:year/code-of-conduct', to: redirect('/code-of-conduct')

  static_page 'terms_and_conditions'
  static_page 'privacy'

  root to: 'festivals#show'

  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?
end
