# app/services/schwab_auth_service.rb
# Este servicio encapsula la lógica de interacción con la gema schwab_rb.
class SchwabAuthService
  # Inicializa el cliente de Schwab con las credenciales y la ruta del token.
  # Asegúrate de que estas variables de entorno estén configuradas en tu entorno de Rails
  # (por ejemplo, en un archivo .env si usas 'dotenv-rails').
  def self.init_schwab_client
    # Lazily initialize the client only once
    @client ||= SchwabRb::Auth.init_client_easy(
      ENV['SCHWAB_API_KEY'],
      ENV['SCHWAB_APP_SECRET'],
      ENV['APP_CALLBACK_URL'],
      ENV['TOKEN_PATH']
    )
  end

  # Obtiene la URL de autorización a la que el usuario debe ser redirigido.
  def self.get_authorization_url
    init_schwab_client
    @client.auth_url
  end

  # Procesa el código de autorización recibido de Schwab y guarda el token.
  # La gema schwab_rb se encarga de persistir el token en la TOKEN_PATH especificada.
  def self.process_callback(authorization_code)
    init_schwab_client
    # La gema schwab_rb maneja automáticamente la solicitud POST para el token
    # y lo guarda en la ubicación especificada por TOKEN_PATH.
    @client.generate_token(authorization_code)
  end
end