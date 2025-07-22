Rails.application.routes.draw do
  resources :debts, only: [ :index, :show ]
end
