Rails.application.routes.draw do
  resources :items
  get 'item/index'

  get 'item/show'

  get 'item/create'

  get 'item/update'

  get 'items/:id/picture', to: 'items#picture_get'
  post 'items/:id/picture', to: 'items#picture_post'
  patch 'items/:id/picture', to: 'items#picture_post'
  get 'items/:id/picture/form', to: 'items#picture_form'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
