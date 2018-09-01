Rails.application.routes.draw do
  resources :reviews
  resources :tweets
  resources :movies
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'application#index'
  get 'save_movie', to: 'application#save_movie'
end
