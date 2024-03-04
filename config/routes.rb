Rails.application.routes.draw do
  root "static_pages#home"
  devise_for :users, controllers:{ registrations: 'users/registrations' , passwords: 'users/passwords'}
  get '/users/show' => 'users#show'
  get '/users/passwordreset', to: 'static_pages#passwordreset'
  get '/users/activation', to: 'static_pages#activation'
  get '/about', to: 'static_pages#about'
  get '/help' , to: 'static_pages#help'
  resources :account_activations, only: [:edit, :update]
  devise_scope :user do
    get '/users', to: 'static_pages#home'
  end
end
