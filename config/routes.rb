Rails.application.routes.draw do
  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  resources :posts do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end

  root to: 'posts#index'
end
