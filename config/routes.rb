require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks', confirmations: 'confirmations' }

  concern :votable do
    member { post :vote }
    member { post :revote }
  end
  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, concerns: [:votable] do
      patch :best, on: :member
      resources :comments, defaults: { commentable: 'answer' }
    end
    resources :comments, defaults: { commentable: 'question' }
    resources :subscriptions, only: %i[create destroy], shallow: true
  end
  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end
      resources :questions, only: %i[index show create update destroy] do
        resources :answers, only: %i[index show create edit update destroy], shallow: true
      end
    end
  end
  root to: 'questions#index'
  get :search, to: 'search#index'
  
  resources :attachments, only: :destroy
  resources :awards, only: :index
end
