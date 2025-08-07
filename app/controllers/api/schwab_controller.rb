class Api::SchwabController < ApplicationController
  # No es necesario autenticar a un usuario existente, ya que estamos creando uno nuevo
  # before_action :authenticate_user!

  def start_auth
    render json: { message: 'Estas en el controlador de Schwab accion start_auth' }, status: :ok
  end

  def callback
    render json: { message: 'Estas en el controlador de Schwab accion callback' }, status: :ok
  end
end