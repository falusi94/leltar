Rails.application.routes.draw do
  # Session routes
  get '/', to: 'session#smart_redirect'

  get 'session/new', as: :login
  post 'session/create'
  post 'session/destroy', as: :logout

  # Photos routes
  post 'photos', to: 'photos#create'
  delete 'photos/:id', to: 'photos#destroy'

  # User routes
  resources :users

  # Right routes
  resources :rights, only: %i[create update destroy]

  # Groups routes
  resources :groups, except: %i[show]
  get 'groups/:group_id/items', to: 'items#index', as: :group_items
  get 'groups/:group_id/items/new', to: 'items#new', as: :new_group_item

  # Items routes
  get 'items/:id/photos/:photo_no', to: 'items#picture_get'
  post 'items/:id/photos', to: 'items#picture_post'
  patch 'items/:id/photos', to: 'items#picture_post'
  delete 'items/:id/photos/:photo_no', to: 'items#picture_delete'
  get 'items/:id/picture/form', to: 'items#picture_form'
  resources :items do
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
