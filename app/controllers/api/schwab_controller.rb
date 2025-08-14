class Api::SchwabController < ApplicationController
  # No es necesario autenticar a un usuario existente, ya que estamos creando uno nuevo
  # before_action :authenticate_user!

  # GET /schwab/start_auth
  # Inicia el proceso de autenticación, redirigiendo al usuario a la página de inicio de sesión de Schwab.
  def start_auth

    # # if current_user.schwab_access_token.present?
    # if current_user.schwab_access_token_expires_at
    #   render json: {
    #     message: "Ya tienes un token de Schwab, no es necesario iniciar sesión de nuevo.",
    #     solicitar_transacciones: root_url.chomp('/') + api_schwab_get_account_trades_path
    #     }, status: :ok
    #   return
    # end

    if current_user.schwab_access_token_expires_at.present? && current_user.schwab_access_token_expires_at > Time.now.utc
      render json: { message: "El usuario tiene un access token válido." }, status: :ok
      return
    else
      # TODO refrescar el access token y regresar al home
      render json: { message: "El usuario tiene un access token vencido." }, status: :ok
      return
    end

    # Asegúrate de que tu clave de API esté configurada en las variables de entorno
    client_id = ENV['SCHWAB_API_KEY']
    
    # La URI de redirección debe coincidir exactamente con la que registraste en Schwab Developer
    redirect_uri = 'https://127.0.0.1:3000/api/schwab/callback'

    # Construye la URL de autenticación con los parámetros necesarios
    auth_url = "https://api.schwabapi.com/v1/oauth/authorize?" +
               "response_type=code" +
               "&client_id=#{client_id}" +
               "&redirect_uri=#{redirect_uri}"

    # Redirige al usuario a la URL de autorización de Schwab
    # redirect_to auth_url, allow_other_host: true

    render json: {
      message: 'Estas en el controlador de Schwab accion start_auth',
      url: auth_url
      }, status: :ok

  end

  # GET /schwab/callback
  # Maneja la respuesta del callback de Schwab después de que el usuario autoriza la aplicación.
  def callback
    time_utc = Time.now.utc
    token_url = URI.parse("https://api.schwabapi.com/v1/oauth/token")

    authorization_code = params[:code]
    redirect_uri = 'https://127.0.0.1:3000/api/schwab/callback'

    payload = {
      grant_type: 'authorization_code',
      code: authorization_code,
      redirect_uri: redirect_uri
    }

    headers = TdaApiClient.authorization_header

    http = Net::HTTP.new(token_url.host, token_url.port)
    http.use_ssl = true # Habilitar SSL/TLS para la conexión

    request = Net::HTTP::Post.new(token_url.request_uri, headers)
    request.set_form_data(payload)

    response = http.request(request)

    case response
    when Net::HTTPSuccess
      token_data = JSON.parse(response.body)

      current_user.update(
        schwab_access_token: token_data['access_token'],
        schwab_refresh_token: token_data['refresh_token'],
        schwab_access_token_expires_at: time_utc + token_data['expires_in'].to_i.seconds,
        schwab_refresh_token_expires_at: time_utc + 7.days
      )

      render json: { status: 'success', token: token_data }
    else
      render json: {
        status: 'error',
        message: 'Error al obtener el token',
        response_code: response.code,
        response_body: response.body
      }, status: :unprocessable_entity
    end
  end

  def refresh_access_token
    time_utc = Time.now.utc

    refresh_token = current_user.schwab_refresh_token

    if refresh_token.nil?
      render json: { error: "No refresh token found. Please authenticate again." }, status: :unauthorized
      return
    end

    if current_user.schwab_access_token_expires_at > Time.now.utc
      render json: { message: "El access token aún es válido." }, status: :ok
      return
    end

    token_url = URI.parse("https://api.schwabapi.com/v1/oauth/token")

    payload = {
      grant_type: 'refresh_token',
      refresh_token: refresh_token
    }

    headers = TdaApiClient.authorization_header
    http = Net::HTTP.new(token_url.host, token_url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(token_url.request_uri, headers)
    request.set_form_data(payload)

    response = http.request(request)

    case response
    when Net::HTTPSuccess
      token_data = JSON.parse(response.body)

      current_user.update(
        schwab_access_token: token_data['access_token'],
        schwab_access_token_expires_at: time_utc + token_data['expires_in'].to_i.seconds,
      )

      render json: { status: 'success', message: 'Token refreshed successfully' }
    else
      render json: {
        status: 'error',
        message: 'Error al refrescar el token',
        response_code: response.code,
        response_body: response.body
      }, status: :unprocessable_entity
    end
  end

  def get_account_numbers
    access_token = current_user.schwab_access_token

    if access_token.nil?
      render json: { error: "No access token found. Please authenticate first." }, status: :unauthorized
      return
    end

    if current_user.schwab_access_token_expires_at < Time.now.utc
      render json: { message: "El access token está vencido, hay que renovarlo." }, status: :ok
      return
    end

    if current_user.schwab_account_number_hash.present?
      render json: { message: "Usuario ya tiene account number." }, status: :ok
      return
    end

    account_numbers_url = URI.parse("https://api.schwabapi.com/trader/v1/accounts/accountNumbers")

    http = Net::HTTP.new(account_numbers_url.host, account_numbers_url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(account_numbers_url.request_uri)
    request['Authorization'] = "Bearer #{access_token}"

    response = http.request(request)

    case response
    when Net::HTTPSuccess
      accounts = JSON.parse(response.body)
      account = accounts.first

      current_user.update(
        schwab_account_number: account['accountNumber'],
        schwab_account_number_hash: account['hashValue'],
      )
      render json: { accounts: account }, status: :ok
    else
      render json: {
        status: 'error',
        message: 'Error al obtener los números de cuenta',
        response_code: response.code,
        response_body: response.body
      }, status: :unprocessable_entity
    end
  end

  def get_account_trades
    access_token = current_user.schwab_access_token
    account_number_hash = current_user.schwab_account_number_hash

    if access_token.nil?
      render json: { error: "No access token found. Please authenticate first." }, status: :unauthorized
      return
    end

    if current_user.schwab_access_token_expires_at < Time.now.utc
      render json: { message: "El access token está vencido, hay que renovarlo." }, status: :ok
      return
    end


    if account_number_hash.nil?
      render json: { error: "No account number found. Please get account numbers first." }, status: :unprocessable_entity
      return
    end

    end_date = Time.now.utc
    start_date = 6.months.ago.utc

    formatted_end_date = end_date.strftime('%Y-%m-%dT%H:%M:%S.000Z')
    formatted_start_date = start_date.strftime('%Y-%m-%dT%H:%M:%S.000Z')

    base_url = "https://api.schwabapi.com/trader/v1/accounts/#{account_number_hash}/transactions"

    params = URI.encode_www_form(
      startDate: formatted_start_date,
      endDate: formatted_end_date,
      types: 'TRADE,RECEIVE_AND_DELIVER,DIVIDEND_OR_INTEREST,ACH_RECEIPT,ACH_DISBURSEMENT,CASH_RECEIPT,CASH_DISBURSEMENT,ELECTRONIC_FUND,WIRE_OUT,WIRE_IN,JOURNAL,MEMORANDUM,MARGIN_CALL,MONEY_MARKET,SMA_ADJUSTMENT'
    )

    full_url = "#{base_url}?#{params}"
    uri = URI.parse(full_url)

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(uri.request_uri)
    request['Authorization'] = "Bearer #{access_token}"

    response = http.request(request)

    case response
    when Net::HTTPSuccess
      transactions = JSON.parse(response.body)
      render json: { status: 'success', transactions: transactions }
    else
      render json: {
        status: 'error',
        message: 'Error al obtener las transacciones',
        response_code: response.code,
        response_body: response.body
      }, status: :unprocessable_entity
    end
  end
end
