Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'tools#index'

  resources :tools, only: %i[new create index]

  # Webhook routes
  post '/webhook' => 'lokalise_apis#webhook'
  get '/create_github_webhook' => 'github_api#create_webhook'

  post '/github/webhook' => 'github_api#webhook'
end
