# frozen_string_literal: true

Rails.application.routes.draw do
  mount Crono::Engine, at: '/crono', constraints: RoutesConstraint::AdminUser

  namespace :api do
    scope module: :v1, constraints: RoutesConstraint::ApiVersion.new(version: 1, default: true) do
      resource :session, only: %i[create destroy]

      resources :users, only: %i[index show create update destroy]

      resources :organizations, only: %i[index create update destroy] do
        resources :items, only: %i[index show update destroy] do
          resources :photos, only: %i[index create destroy], module: :items
          resource :invoice, only: %i[show create destroy], module: :items
        end

        resources :departments, only: %i[index show create update destroy] do
          resources :items, only: %i[index create]
        end

        resources :department_users, only: %i[index create update destroy]
      end

      resources :system_attributes, only: [:index] do
        put :update, on: :collection
      end
    end
  end

  namespace :setup do
    resources :users, only: %i[new create]
    resources :organizations, only: %i[new create]
  end

  scope module: :web do
    get '/', to: 'redirect#show'
    root to: 'redirect#show'

    resource :session, only: %i[new create] do
      get 'destroy', on: :collection, as: :destroy
    end


    scope 'org/:organization_slug' do
      resources :organizations, except: :show, param: :slug

      resource :depreciation_config, only: %i[show edit update]

      resources :users

      resources :department_users, only: %i[create update destroy]

      resources :departments, except: :show do
        resources :items, only: %i[index new]
      end

      resources :items do
        resources :photos, only: %i[create destroy], module: :items
        resource :invoice, only: %i[create destroy], module: :items

        resource :status_check, only: :create, module: :items
        resources :versions, only: :show, module: :items
      end

      resources :locations, only: %i[index new create edit update destroy]

      resources :search, only: %i[index]

      resources :status, only: :index

      resources :system_attributes, only: [] do
        get :edit, on: :collection
        put :update, on: :collection
      end
    end
  end
end
