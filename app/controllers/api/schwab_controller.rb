class Api::SchwabController < ApplicationController
  # before_action :authenticate_user!

  before_action :ensure_valid_schwab_token, except: [:start_auth, :callback]

  def start_auth
    if current_user.schwab_access_token_is_valid?
      render json: { message: "El usuario tiene un access token válido." }, status: :ok
    else
      auth_url = SchwabApiService.build_auth_url
      render json: { message: 'Redireccionando para autorización de Schwab...', url: auth_url }, status: :ok
    end
  end

  def callback
    response = SchwabApiService.exchange_code_for_token(params[:code])

    if response[:status] == :success
      update_broker_conexions_tokens(response[:body])
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
        update_broker_conexions_account(account)
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
    return if current_user.schwab_access_token_is_valid?

    # Si el token de acceso está vencido, intentamos refrescarlo.
    if current_user.schwab_refresh_token_is_valid?
      response = SchwabApiService.refresh_access_token(current_user.schwab_refresh_token)

      if response[:status] == :success
        update_broker_conexions_tokens(response[:body])
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

  def update_broker_conexions_tokens(token_data)
    time_utc = Time.now.utc
    access_token = BrokerConexion.find_by_key_and_broker('access_token', 'schwab')
    access_token.update(
      value: token_data['access_token'],
      expires_at: time_utc + token_data['expires_in'].to_i.seconds,
      ) if access_token

      if token_data['refresh_token']
      refresh_token = BrokerConexion.find_by_key_and_broker('refresh_token', 'schwab')
      refresh_token.update(
        value: token_data['refresh_token'],
        expires_at: time_utc + 7.days
      ) if refresh_token
    end
  end

  def update_broker_conexions_account(account)
    account_number = BrokerConexion.find_by_key_and_broker('account_number', 'schwab')
    account_number_hash = BrokerConexion.find_by_key_and_broker('account_number_hash', 'schwab')

    account_number.update(value: account['accountNumber']) if account_number
    account_number_hash.update(value: account['hashValue']) if account_number_hash
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
