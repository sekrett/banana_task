Rails.application.routes.draw do
  devise_for :users, path_names: { sign_in: 'login', sign_out: 'logout', sign_up: 'register' }
  resources :posts do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end
  get 'tags/:tag', to: 'posts#index', as: :tag

  namespace 'api' do
    namespace 'v1' do
      resources :posts, only: [] do
        resources :comments, only: [:index, :create, :destroy]
      end
    end
  end

  root to: 'posts#index'
end
