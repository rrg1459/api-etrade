# app/controllers/api/etrade_controller.rb
class Api::EtradeController < ApplicationController
  # Supongamos que tienes un usuario autenticado y un modelo User
  before_action :authenticate_user!

  def start_auth
    etrade_service = EtradeOauthService.new
    request_token = etrade_service.get_request_token

    # Guarda el request_token y su secret en la sesión del usuario o en la base de datos
    # Esto es crucial para el siguiente paso
    session[:etrade_request_token] = request_token.token
    session[:etrade_request_token_secret] = request_token.secret

    authorization_url = etrade_service.authorization_url(request_token)

    render json: { authorization_url: authorization_url }, status: :ok
  end

  def callback
    # Esta acción se activará cuando el usuario sea redirigido desde E*TRADE
    # con el PIN de verificación

    oauth_verifier = params[:oauth_verifier]

    if oauth_verifier.blank?
      render json: { error: 'No se proporcionó un PIN de verificación.' }, status: :bad_request
      return
    end

    etrade_service = EtradeOauthService.new
    
    # Reconstruye el Request Token a partir de los datos guardados en la sesión
    request_token = OAuth::RequestToken.new(
      etrade_service.instance_variable_get(:@consumer),
      session[:etrade_request_token],
      session[:etrade_request_token_secret]
    )

    access_token = etrade_service.get_access_token(request_token, oauth_verifier)

    # Guarda el Access Token y el Access Secret del usuario en la base de datos
    current_user.update(
      etrade_access_token: access_token.token,
      etrade_access_secret: access_token.secret
    )

    # Limpia la sesión
    session.delete(:etrade_request_token)
    session.delete(:etrade_request_token_secret)

    render json: { message: 'Autenticación con E*TRADE exitosa.' }, status: :ok
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
