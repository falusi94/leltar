Rails.application.routes.draw do
  resources :items
  get 'item/index'

  get 'item/show'

  get 'item/create'

  get 'item/update'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
