Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'tools#index'

  resources :tools, only: %i[new create index]

  post '/webhook' => 'lokalise_apis#webhook'
  post '/github/webhook' => 'github_api#webhook'
end
