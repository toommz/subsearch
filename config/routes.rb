Subsearch::Application.routes.draw do
  root 'search#index'

  post 'search', to: 'search#search', as: 'search'
end
