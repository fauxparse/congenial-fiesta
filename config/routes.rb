# frozen_string_literal: true

Rails.application.routes.draw do
  get    '/login'  => 'sessions#new', as: :login
  post   '/login'  => 'sessions#create'
  delete '/logout' => 'sessions#destroy', as: :logout

  root to: 'festivals#show'
end
