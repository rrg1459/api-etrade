# app/services/etrade_oauth_service.rb
require 'oauth'

class EtradeOauthService
  # Configuración de tus credenciales de la sandbox
  CONSUMER_KEY    = ENV['7057a90cb469e10cd243e8437a34dcb6']
  CONSUMER_SECRET = ENV['51101a3c9e9512ad774f6e1d0267e72e330f89006553c1ef06d07daac6b9ae8a']

  # URLs de la API de E*TRADE para la sandbox
  API_BASE_URL    = 'https://apisb.etrade.com'
  REQUEST_TOKEN_PATH = '/oauth/request_token'
  ACCESS_TOKEN_PATH  = '/oauth/access_token'
  AUTHORIZE_URL      = 'https://us.etrade.com/e/t/etws/authorize'

  def initialize
    # El objeto OAuth::Consumer se inicializa una vez con las credenciales
    @consumer = OAuth::Consumer.new(
      CONSUMER_KEY,
      CONSUMER_SECRET,
      site: API_BASE_URL,
      scheme: :header,
      http_method: :get,
      signature_method: 'HMAC-SHA1',
      request_token_path: REQUEST_TOKEN_PATH,
      access_token_path: ACCESS_TOKEN_PATH
    )
  end

  # Paso 1: Obtener el Request Token
  def get_request_token
    begin
      @consumer.get_request_token
    rescue OAuth::Unauthorized => e
      raise "Error de autenticación con E*TRADE: #{e.message}"
    end
  end

  # Paso 2: Generar la URL de autorización para el usuario
  def authorization_url(request_token)
    "#{AUTHORIZE_URL}?oauth_token=#{request_token.token}"
  end

  # Paso 3: Obtener el Access Token (usando el Request Token y el PIN de verificación)
  def get_access_token(request_token, oauth_verifier)
    begin
      request_token.get_access_token(oauth_verifier: oauth_verifier)
    rescue OAuth::Unauthorized => e
      raise "Error al obtener el Access Token: #{e.message}"
    end
  end
end