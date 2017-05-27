Rails.application.routes.draw do
  post 'photos', to: 'photos#create'
  delete 'photos/:id', to: 'photos#destroy'

  resources :groups, only: [:index, :edit, :create, :destroy, :update, :new]
  get 'groups/:group', to: 'items#index'
  put 'groups/:group', to: 'items#update_all'
  get '/', to: 'session#smart_redirect'
  get 'session/new'

  post 'session/create'

  post 'session/destroy'

  resources :users
  resources :items
  get 'item/index'

  get 'item/show'

  get 'item/create'

  get 'item/update'
  put '/items', to: 'items#update_all'
  post '/items_csv', to: 'items#upload_csv'

  get 'items/:id/photos/:photo_no', to: 'items#picture_get'
  post 'items/:id/photos', to: 'items#picture_post'
  patch 'items/:id/photos', to: 'items#picture_post'
  delete 'items/:id/photos/:photo_no', to: 'items#picture_delete'
  get 'items/:id/picture/form', to: 'items#picture_form'
  get 'items/:id/versions/:version_idx', to: 'items#show'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
