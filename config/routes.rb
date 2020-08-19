Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :tools, only: %i[new create]

  post '/webhook' => 'lokalise_apis#webhook'
end
