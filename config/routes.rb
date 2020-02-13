Rails.application.routes.draw do
  resources :organizations, only: %i[show] do
    resources :projects, only: %i[index create show update destroy]
  end
end
