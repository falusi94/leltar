Rails.application.routes.draw do
  get '/', to: 'redirect#show'

  resource :session, only: %i[new create] do
    get 'destroy', on: :collection, as: :destroy
  end

  # User routes
  resources :users

  # Right routes
  resources :rights, only: %i[create update destroy]

  # Groups routes
  resources :groups, except: :show do
    resources :items, only: %i[index new]
  end

  # Items routes
  resources :items do
    resources :photos, only: %i[create destroy]
    resources :invoices, only: %i[create destroy]

    post 'check', to: 'items#update_last_check', as: :check
    get 'versions/:version_idx', to: 'items#show', as: :version
  end

  # Import routes
  resources :import, only: %i[new edit create update]

  # Search routes
  resources :search, only: %i[index]
  get 'search/export', to: 'search#export', as: :search_export

  # Status routes
  resources :status, only: %i[index]
  get 'status/edit', to: 'status#edit', as: :edit_status
  post 'status', to: 'status#update', as: :update_status
end
