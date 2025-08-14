class Api::SchwabController < ApplicationController
  # before_action :authenticate_user!

  before_action :ensure_valid_schwab_token, except: [:start_auth, :callback]

  def start_auth
    if current_user.schwab_token_is_valid?
      render json: { message: "El usuario tiene un access token válido." }, status: :ok
    else
      auth_url = SchwabApiService.build_auth_url
      render json: { message: 'Redireccionando para autorización de Schwab...', url: auth_url }, status: :ok
    end
  end

  def callback
    response = SchwabApiService.exchange_code_for_token(params[:code])

    if response[:status] == :success
      update_user_tokens(response[:body])
      render json: { status: 'success', message: 'Token recibido y guardado.' }
    else
      render_error(response)
    end
  end

  def get_account_numbers
    if current_user.schwab_account_number_hash.present?
      render json: { message: "Usuario ya tiene account number." }, status: :ok
    else
      response = SchwabApiService.get_account_numbers(current_user.schwab_access_token)
      if response[:status] == :success
        account = response[:body].first
        current_user.update(schwab_account_number: account['accountNumber'], schwab_account_number_hash: account['hashValue'])
        render json: { accounts: account }, status: :ok
      else
        render_error(response)
      end
    end
  end

  def get_account_trades
    response = SchwabApiService.get_account_transactions(
      current_user.schwab_access_token,
      current_user.schwab_account_number_hash,
      6.months.ago,
      Time.now
    )

    if response[:status] == :success
      render json: { status: 'success', transactions: response[:body] }
    else
      render_error(response)
    end
  end

  private

  def ensure_valid_schwab_token
    # Si el token de acceso es válido, no hacemos nada más.
    return if current_user.schwab_token_is_valid?

    # Si el token de acceso está vencido, intentamos refrescarlo.
    if current_user.schwab_refresh_token_is_valid?
      response = SchwabApiService.refresh_access_token(current_user.schwab_refresh_token)

      if response[:status] == :success
        update_user_tokens(response[:body])
        # El token se ha refrescado con éxito, la acción del controlador puede continuar.
      else
        # Hubo un error al refrescar el token (ej. token_refresco inválido).
        # Lo marcamos para que el usuario se reautentique.
        render_error(response, "Error al refrescar el token. Por favor, reautentíquese.")
      end
    else
      # Si el token de refresco también está vencido o no existe,
      # el usuario debe reautenticarse por completo.
      render json: {
        error: 'El token de acceso y de refresco no son válidos. Por favor, autentícate de nuevo.',
        action_required: :reauthenticate
      }, status: :unauthorized
    end
  end

  def refresh_token_action
    response = SchwabApiService.refresh_access_token(current_user.schwab_refresh_token)
    if response[:status] == :success
      update_user_tokens(response[:body])
    else
      render_error(response)
    end
  end

  def update_user_tokens(token_data)
    time_utc = Time.now.utc
    current_user.update(
      schwab_access_token: token_data['access_token'],
      schwab_refresh_token: token_data['refresh_token'] || current_user.schwab_refresh_token,
      schwab_access_token_expires_at: time_utc + token_data['expires_in'].to_i.seconds,
      # El refresh token solo se obtiene en la autenticación inicial, no en el refresh
      schwab_refresh_token_expires_at: token_data['refresh_token'] ? time_utc + 7.days : current_user.schwab_refresh_token_expires_at
    )
  end

  def render_error(response, message_override = nil)
    render json: {
      status: 'error',
      message: message_override || 'Error en la comunicación con la API de Schwab',
      response_code: response[:code],
      response_body: response[:body]
    }, status: :unprocessable_entity
  end
end
