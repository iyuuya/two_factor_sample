Rails.application.routes.draw do
  root to: 'home#index'

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }
  devise_scope :user do
    patch 'users/confirmation', to: 'users/confirmations#confirm'
    post 'users/sign_up/confirm', to: 'users/registrations#confirm'
  end
  resources :groups
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  
  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end
end
