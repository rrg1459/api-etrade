# config/routes.rb
Rails.application.routes.draw do
  # ... otras rutas
  namespace :api do
    get '/etrade/start_auth', to: 'etrade#start_auth'
    get '/etrade/callback', to: 'etrade#callback'
    get '/schwab/start_auth', to: 'schwab#start_auth'
    get '/schwab/callback', to: 'schwab#callback'
  end
    root "home#initial"

end