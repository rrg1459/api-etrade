# lib/tda_api_client.rb
module TdaApiClient
  def self.authorization_header
    client_id = ENV['SCHWAB_API_KEY']
    client_secret = ENV['SCHWAB_APP_SECRET']
    auth_string = Base64.strict_encode64("#{client_id}:#{client_secret}")
    {
      'Content-Type' => 'application/x-www-form-urlencoded',
      'Authorization' => "Basic #{auth_string}"
    }
  end
end
