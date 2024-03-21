# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    scope module: :v1, constraints: RoutesConstraint::ApiVersion.new(version: 1, default: true) do
      resource :session, only: %i[create destroy]
      resources :items, only: %i[index show update destroy] do
        resources :photos, only: %i[index create destroy], module: :items
        resource :invoice, only: %i[show create destroy], module: :items
      end

      resources :departments, only: %i[index show create update destroy] do
        resources :items, only: %i[index create]
      end

      resources :users, only: %i[index show create update destroy]
      resources :department_users, only: %i[create update destroy]

      resources :system_attributes, only: [:index] do
        put :update, on: :collection
      end
    end
  end

  scope module: :web do
    get '/', to: 'redirect#show'
    root to: 'redirect#show'

    resource :session, only: %i[new create] do
      get 'destroy', on: :collection, as: :destroy
    end

    # User routes
    resources :users

    # DepartmentUser routes
    resources :department_users, only: %i[create update destroy]

    # Departments routes
    resources :departments, except: :show do
      resources :items, only: %i[index new]
    end

    # Items routes
    resources :items do
      resources :photos, only: %i[create destroy], module: :items
      resource :invoice, only: %i[create destroy], module: :items

      resource :status_check, only: :create, module: :items
      resources :versions, only: :show, module: :items
    end

    # Search routes
    resources :search, only: %i[index]

    # Status routes
    resources :status, only: :index

    resources :system_attributes, only: [] do
      get :edit, on: :collection
      put :update, on: :collection
    end
  end
end
