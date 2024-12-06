Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Defines the root path route ("/")
  # root "articles#index"
  
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:confirmations]

  devise_scope :user do
    delete '/auth/logout_all', to: 'auth/sessions#logout_all'
  end  

  get 'test', to: 'test#test'
end
