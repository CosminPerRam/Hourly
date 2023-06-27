Rails.application.routes.draw do
  resources :messages
  resources :likes, only: [:create]

  devise_for :users

  root 'home#index'
end
