# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  get 'home/index'
  devise_for :users

  # Users routes
  get 'users/mypage', to: 'users#mypage', as: 'users_mypage'

  # Posts routes
  resources :posts, only: [:new, :create]

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Sidekiq Web interface
  # TODO: sidekiq を見られる範囲を限定する。
  #       e.g. admins をつくって authenticate する？
  mount Sidekiq::Web => '/sidekiq'

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  root 'home#index'
end
