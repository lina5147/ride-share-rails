Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root to: 'homepages#index'

  resources :passengers do
    resources :trips, only: [:create, :destroy]
  end

  resources :drivers do
    resources :trips, only: [:destroy]
  end

  resources :trips, except: [:index, :new]

end
