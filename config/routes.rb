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
  resources :rights, only: [:create, :update, :destroy]

  # Groups routes
  resources :groups, except: [:show]
  get 'groups/:group_id/items', to: 'items#index', as: :group_items
  get 'groups/:group_id/items/new', to: 'items#new', as: :new_group_item

  # Items routes
  resources :items
  post 'items/{:id}/check', to: 'items#update_last_check', as: :check_item

  get 'items/:id/photos/:photo_no', to: 'items#picture_get'
  post 'items/:id/photos', to: 'items#picture_post'
  patch 'items/:id/photos', to: 'items#picture_post'
  delete 'items/:id/photos/:photo_no', to: 'items#picture_delete'
  get 'items/:id/picture/form', to: 'items#picture_form'
  get 'items/:id/versions/:version_idx', to: 'items#show'

  # Import routes
  resources :import, only: %i[new edit create update]
  #put 'items', to: 'items#update_all'
  #post 'items_csv', to: 'import#upload_csv'
end
