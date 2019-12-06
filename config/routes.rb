Rails.application.routes.draw do
  get 'favorites/create'
  get 'comments/create'
  get 'comment/create'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'songs#index'
  resources :songs, only: [:show, :new, :create] do
  	post 'find_videos', on: :collection
  	resources :comments
  	resource :favorites, only: [:create, :destroy]
  end
  resources :users, only: [:show]

end
