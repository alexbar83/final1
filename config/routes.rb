Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#index'

  concern :votable do
    member { post :vote }
    member { post :revote }
  end

  resources :questions, concerns: [:votable] do
    resources :answers, shallow: true, concerns: [:votable] do
      patch :best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :awards, only: :index
end
