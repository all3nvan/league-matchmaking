Rails.application.routes.draw do
  root 'players#index', defaults: { format: :json }
  resources :matchmaking, only: [:new], defaults: { format: :json }
  resources :matchmaking, only: [:create]
  resources :match, only: [:index]
  resources :players, only: [:index, :show], defaults: { format: :json }
  resources :champions, only: [:index]
end
