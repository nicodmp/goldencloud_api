Rails.application.routes.draw do
  resources :debts, only: [ :index, :show ] do
    collection do
      post :import
      post :pay
    end
  end
end
