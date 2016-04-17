class PlayersController < ApplicationController
  before_filter :cors_set_access_control_headers

  def index
    @players = Player.all.sort_by(&:trueskill).reverse
  end

  def show
    @player = Player.find(params[:id])
  end

  private

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'GET'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
end
