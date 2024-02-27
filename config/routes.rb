Rails.application.routes.draw do
  root "static_pages#home"
  devise_for :users, controllers:{ registrations: 'users/registrations' , passwords: 'users/passwords'}
  get '/users/show' => 'users#show'
  get '/users/passwordreset', to: 'static_pages#passwordreset'
  get '/about', to: 'static_pages#about'
  get '/help' , to: 'static_pages#help'
end
