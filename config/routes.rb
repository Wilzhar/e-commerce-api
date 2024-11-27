Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  
  # Defines the root path route ("/")
  # root "articles#index"
  
  mount_devise_token_auth_for 'User', at: 'auth', skip: [:confirmations]

  namespace :auth do
    delete 'logout_all', to: 'sessions#logout_all'
  end

  get 'test', to: 'test#test'
end
