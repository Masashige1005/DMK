# frozen_string_literal: true

Rails.application.routes.draw do
  get 'communities/index'
  get 'communities/show'
  get 'communities/create'
  get 'communities/destroy'
  get 'favorites/create'
  get 'comments/create'
  get 'comment/create'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'songs#index'
  resources :songs, only: %i[show new create] do
    post 'find_videos', on: :collection
    resources :comments
    resource :favorites, only: %i[create destroy]
  end
  resources :users, only: [:show] do
    post 'follow', on: :member
    post 'unfollow', on: :member
    get 'following', on: :member
    get 'followed', on: :member
  end

  get 'search', to: 'songs#search_results', via: %i[get post]
end
