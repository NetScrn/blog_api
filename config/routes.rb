Rails.application.routes.draw do
  resources :posts, only: :create do
    post :rate, as: :member
    collection do
      get :top_ave
      get :dup_ips
    end
  end
end
