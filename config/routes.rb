Rails.application.routes.draw do
  devise_for :users, skip: :all
  devise_scope :user do
    get 'sign_up', to: 'registration#new' 
    post 'sign_up', to: 'registration#create'
    
    get 'sign_in', to: 'sessions#new'
    post 'sign_in', to: 'sessions#create'
    delete 'sign_out', to: 'sessions#destroy'
    
    resources :user do 
    #get "main", to: "user#index" 
    end

    root to: 'sessions#new'
  end
end
