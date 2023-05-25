# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'transactions#index'

  resources :merchants, only: %i[index edit update destroy]
  resources :transactions, only: :index

  namespace :api, defaults: { format: :json } do
    resources :transactions, only: :create
  end
end
