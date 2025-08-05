class HomeController < ApplicationController

  def initial
    render json: { message: 'Bienvenido a la API de E*TRADE' }, status: :ok
  end
end
