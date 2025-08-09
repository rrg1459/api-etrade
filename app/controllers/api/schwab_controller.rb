class Api::SchwabController < ApplicationController
  # No es necesario autenticar a un usuario existente, ya que estamos creando uno nuevo
  # before_action :authenticate_user!

  # GET /schwab/start_auth
  # Inicia el proceso de autenticación, redirigiendo al usuario a la página de inicio de sesión de Schwab.
  def start_auth
    begin
      auth_url = SchwabAuthService.get_authorization_url

      puts
      puts '*'*40
      puts '*'*40
      puts "--> #{__method__} <--"
      puts
      puts "auth_url: #{auth_url}"
      puts
      puts '*'*40
      puts '*'*40
      puts

      render json: { message: 'Estas en el controlador de Schwab accion start_auth' }, status: :ok

    rescue StandardError => e
      render json: { error: "Ocurrió un error: #{e.message}" }, status: :internal_server_error
    end
  end

  # GET /schwab/callback
  # Maneja la respuesta del callback de Schwab después de que el usuario autoriza la aplicación.
  def callback
    begin
      # El código de autorización se encuentra en params[:code]
      # Es crucial que SchwabAuthService maneje la lógica de guardar el token.
      service = SchwabAuthService.process_callback(params[:code])

      puts
      puts '*'*40
      puts '*'*40
      puts "--> #{__method__} <--"
      puts
      puts "service: #{service}"
      puts
      puts '*'*40
      puts '*'*40
      puts
      byebug

      render json: { message: 'Estas en el controlador de Schwab accion callback' }, status: :ok

    rescue StandardError => e
      render json: { error: "Ocurrió un error en callback: #{e.message}" }, status: :internal_server_error
    end
  end
end