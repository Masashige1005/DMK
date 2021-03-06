# frozen_string_literal: true

Rails.application.routes.draw do
  get 'home/about'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'songs#index'
  resources :songs, only: %i[show new create edit update destroy] do
    post 'find_videos', on: :collection
    post 'ituens_search', on: :collection
    resources :comments
    resource :favorites, only: %i[create destroy]
  end

  resources :users, only: %i[show update] do
    post 'follow', on: :member
    post 'unfollow', on: :member
    get 'following', on: :member
    get 'followed', on: :member
  end

  resources :communities, only: %i[index show new create destroy edit update] do
    resources :community_users, only: %i[create destroy]
    resources :community_comments, only: %i[create destroy]
  end

  get 'search', to: 'songs#search_results', via: %i[get post]
end
