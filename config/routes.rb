Rails.application.routes.draw do
  devise_for :users, skip: :all
  devise_scope :user do
    get 'sign_up', to: 'registration#new' 
    post 'sign_up', to: 'registration#create'
    
    get 'sign_in', to: 'sessions#new'
    post 'sign_in', to: 'sessions#create'
    delete 'sign_out', to: 'sessions#destroy'
    
    post 'new_post', to: 'post#create'
    get 'new_post', to: 'post#new'
    get 'post/:id', to: 'post#show', as: :post
    delete 'delete_post', to: 'post#destroy'

    get 'search', to: 'user#index'
    get 'user/:id', to: 'user#show', as: :user

    get 'feed', to: 'feed#index'

    post "create_comment", to: "comment#create"
    delete "delete_comment", to: "comment#destroy"
    put "update_comment", to: "comment#update"
    get "update_comment/:comment_id", to: "comment#show"

    root to: 'sessions#new'
  end
end
