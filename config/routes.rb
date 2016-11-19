Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root to: 'home#index'

  namespace "api" do
    resources :users, only: [:create, :update] do
      collection do
        post :login
        post :reset_password
      end
    end
	end
end
