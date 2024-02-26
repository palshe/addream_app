Rails.application.routes.draw do
  root "static_pages#home"
  devise_for :users, controllers:{ registrations: 'users/registrations' }
  get '/users/show' => 'users#show'
  get '/about', to: 'static_pages#about'
  get '/help' , to: 'static_pages#help'
end
