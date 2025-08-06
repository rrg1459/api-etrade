# app/controllers/api/etrade_controller.rb
class Api::EtradeController < ApplicationController
  # No es necesario autenticar a un usuario existente, ya que estamos creando uno nuevo
  # before_action :authenticate_user!

  def start_auth
    etrade_service = EtradeOauthService.new

    begin
      request_token = etrade_service.get_request_token

      # Creamos un nuevo usuario y guardamos los tokens
      # En un escenario real, también tendrías otros datos del usuario aquí
      # como email o nombre, pero para este ejemplo, solo usaremos los tokens.
      user = User.new(
        etrade_request_token: request_token.token,
        etrade_request_token_secret: request_token.secret
      )

      if user.save
        # Una vez guardado, podemos usar su ID para reconstruir el flujo en el callback
        authorization_url = etrade_service.authorization_url(request_token)

        # Guardamos la URL y el ID del usuario en la respuesta
        render json: { 
          authorization_url: authorization_url,
          user_id: user.id
        }, status: :ok
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end

    rescue StandardError => e
      render json: { error: "Ocurrió un error: #{e.message}" }, status: :internal_server_error
    end
  end

  def callback
    # Recuperamos los datos del usuario del callback
    # user_id = params[:user_id] 
    # oauth_verifier = params[:oauth_verifier]
    # oauth_verifier = '985178'
    # oauth_verifier = '618783'
    oauth_verifier = '674512'

    user = User.last

    if user.nil?
      render json: { error: 'Usuario no encontrado.' }, status: :not_found
      return
    end

    etrade_service = EtradeOauthService.new

    # Reconstruye el Request Token a partir de los datos guardados en la base de datos
    request_token = OAuth::RequestToken.new(
      etrade_service.instance_variable_get(:@consumer),
      user.etrade_request_token,
      user.etrade_request_token_secret
    )

    request_token.params['oauth_callback'] = EtradeOauthService::CALLBACK_URL

    access_token = etrade_service.get_access_token(request_token, oauth_verifier)

    # Actualizamos los tokens permanentes del usuario y limpiamos los temporales
    if user.update(
      etrade_access_token: access_token.token,
      etrade_access_secret: access_token.secret,
      etrade_request_token: nil,
      etrade_request_token_secret: nil
    )
      render json: { message: 'Autenticación con E*TRADE exitosa.' }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end

  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end