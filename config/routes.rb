# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  root 'transactions#index'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get '/logout' => 'sessions#destroy'

  resources :merchants, only: %i[index edit update destroy]
  resources :transactions, only: :index

  namespace :api, defaults: { format: :json } do
    resources :transactions, only: :create
  end
end
