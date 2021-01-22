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
    get 'my_posts', to: 'post#index'
    get 'post/:id', to: 'post#show', as: :post
    delete 'delete_post', to: 'post#destroy'
    #resources :post
    resources :user

    root to: 'sessions#new'
  end
end
