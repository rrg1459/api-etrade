# config/routes.rb
Rails.application.routes.draw do
  # ... otras rutas
  namespace :api do
    get '/etrade/start_auth', to: 'etrade#start_auth'
    get '/etrade/callback', to: 'etrade#callback'
  end
    root "home#initial"

end