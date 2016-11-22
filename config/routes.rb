Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'home#index'

  # api for kakao
  get '/keyboard', to: 'keyboard#show'
  post '/message', to: 'message#create'
  post '/friend', to: 'friend#create'
  delete '/friend/:user_key', to: 'friend#destroy'
  delete '/chat_room/:user_key', to: 'chat_room#destroy'

  namespace "api" do
    resources :users, only: [:create, :update] do
      collection do
        post :login
        post :reset_password
      end
    end
	end
end
