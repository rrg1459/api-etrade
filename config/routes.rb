# config/routes.rb
Rails.application.routes.draw do
  # ... otras rutas
  namespace :api do
    get '/etrade/start_auth', to: 'etrade#start_auth'
    get '/etrade/callback', to: 'etrade#callback'
    get '/schwab/start_auth', to: 'schwab#start_auth'
    get '/schwab/callback', to: 'schwab#callback'
    get '/schwab/refresh_access_token', to: 'schwab#refresh_access_token'
    get '/schwab/get_account_numbers', to: 'schwab#get_account_numbers'
    get '/schwab/get_account_trades', to: 'schwab#get_account_trades'
  end
    root "home#initial"

end
