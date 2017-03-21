Rails.application.routes.draw do
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

  get 'items/:id/picture', to: 'items#picture_get'
  post 'items/:id/picture', to: 'items#picture_post'
  patch 'items/:id/picture', to: 'items#picture_post'
  get 'items/:id/picture/form', to: 'items#picture_form'
  get 'items/:id/versions/:version_idx', to: 'items#show'
  get 'groups', to: 'items#group_index'
  get 'groups/:group', to: 'items#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
