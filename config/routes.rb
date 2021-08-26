# frozen_string_literal: true

Rails.application.routes.draw do
  resources :organizations, only: %i[show] do
    resources :projects, only: %i[index create show update destroy]
  end

  resources :projects, only: [] do
    resources :tasks, only: %i[index create show update destroy]
  end
end
